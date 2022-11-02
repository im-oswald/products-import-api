# frozen_string_literal: true

module Api
  module V1
    class ImportsController < ApplicationController

      def index
        categories = Category.all
        render json: {
          categories: ActiveModelSerializers::SerializableResource.new(categories, each_serializer: CategorySerializer),
          message: ['Categories listed successfully'],
          status: 200,
          type: 'Success'
        }
      end

      def create
        file_names = params.keys.select { |param| param.include?("file") }
        file_names.each { |name| ImportProductsJob.perform_later(params[name].path) }
        render json: { success: true }, status: :ok
      rescue => e
        render json: { error: "CSV not imported" }, status: :unprocessable_entity
      end
    end
  end
end
