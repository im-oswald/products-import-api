# frozen_string_literal: true

module Api
  module V1
    class ImportsController < ApplicationController
      def index
        categories = Category.all.offset(params[:offset]).limit(params[:limit])
        render json: {
          categories: ActiveModelSerializers::SerializableResource.new(categories, each_serializer: CategorySerializer),
          message: ['Categories listed successfully'],
        },
        status: :ok
      rescue StandardError
        render json: { error: 'Categories not found' }, status: :unprocessable_entity
      end

      def show
        products = Category.find_by_id(params[:id]).products.offset(params[:offset]).limit(params[:limit])
        render json: {
          products: products
        }
      end


      def create
        file_names = params.keys.select { |param| param.include?("file") }
        file_names.each { |name| ImportProductsJob.perform_later(params[name].path) }
        render json: { message: 'Successfully created records.' }, status: :created
      rescue => e
        render json: { error: "Error occurred during Csv processing." }, status: :unprocessable_entity
      end
    end
  end
end
