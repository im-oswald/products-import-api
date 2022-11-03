# frozen_string_literal: true

require 'rails_helper'
require 'csv'

RSpec.describe 'Imports', type: :request do
  include ActiveJob::TestHelper

  describe '#index' do
    context 'when there are no products or categories' do
      it 'will return empty response' do
        get api_v1_imports_path

        expect(JSON.parse(response.body)['categories']).to match_array([])
      end
    end

    context 'when there are products and categories' do
      let!(:product) { create(:product) }

      it 'will return a category' do
        get api_v1_imports_path

        expect(JSON.parse(response.body)['categories'].length).to eq 1
      end

      it 'will return product nested in category' do
        get api_v1_imports_path

        expect(JSON.parse(response.body)['categories'].first['name']).to eq(product.category.name)
        expect(JSON.parse(response.body)['categories'].first['products'].length).to eq 1
        expect(JSON.parse(response.body)['categories'].first['products'].first['upc']).to eq(product.upc)
      end
    end
  end

  describe '#create' do
    let(:csv_file) do
      CSV.open('spec/csv_file.csv', 'w', write_headers: true, headers: %w[date product_id weight unit]) do |csv|
        csv << csv_record
      end
    end

    context 'when data is missing' do
      context 'when all items are missing' do
        let(:csv_record) { [] }

        it 'does not create product' do
          expect do
            post api_v1_imports_path,
                 params: { file: Rack::Test::UploadedFile.new(csv_file.path, 'text/csv', true) }
          end.not_to change(Product, :count)
        end
      end

      context 'when unit is missing' do
        let(:csv_record) do
          [Faker::Time.between(from: DateTime.now - 3, to: DateTime.now - 1),
           Faker::Alphanumeric.alphanumeric(number: 10).insert(3, '-'),
           Faker::Number.decimal(l_digits: 2)]
        end

        it 'does not create product' do
          expect do
            post api_v1_imports_path,
                 params: { file: Rack::Test::UploadedFile.new(csv_file.path, 'text/csv', true) }
          end.not_to change(Product, :count)
        end
      end

      context 'when date is missing' do
        let(:csv_record) do
          [nil,
           Faker::Alphanumeric.alphanumeric(number: 10).insert(3, '-'),
           Faker::Number.decimal(l_digits: 2),
           %w[kilograms pounds grams].sample]
        end

        it 'does not create product' do
          expect do
            post api_v1_imports_path,
                 params: { file: Rack::Test::UploadedFile.new(csv_file.path, 'text/csv', true) }
          end.not_to change(Product, :count)
        end
      end

      context 'when product_id is missing is missing' do
        let(:csv_record) do
          [Faker::Time.between(from: DateTime.now - 3, to: DateTime.now - 1),
           nil,
           Faker::Number.decimal(l_digits: 2),
           %w[kilograms pounds grams].sample]
        end

        it 'does not create product' do
          expect do
            post api_v1_imports_path,
                 params: { file: Rack::Test::UploadedFile.new(csv_file.path, 'text/csv', true) }
          end.not_to change(Product, :count)
        end
      end

      context 'when weight is missing' do
        let(:csv_record) do
          [Faker::Time.between(from: DateTime.now - 3, to: DateTime.now - 1),
           Faker::Alphanumeric.alphanumeric(number: 10).insert(3, '-'),
           nil,
           %w[kilograms pounds grams].sample]
        end

        it 'creates product' do
          post api_v1_imports_path, params: { file: Rack::Test::UploadedFile.new(csv_file.path, 'text/csv', true) }

          perform_enqueued_jobs
          expect(response).to have_http_status(:created)
          expect(Product.count).to eq 1
          expect(Product.first.upc).to eq(csv_record.second)
        end
      end
    end

    context 'when data is correct' do
      let(:csv_record) do
        [Faker::Time.between(from: DateTime.now - 3, to: DateTime.now - 1),
         Faker::Alphanumeric.alphanumeric(number: 10).insert(3, '-'),
         Faker::Number.decimal(l_digits: 2),
         %w[kilograms pounds grams].sample]
      end

      it 'creates product' do
        post api_v1_imports_path, params: { file: Rack::Test::UploadedFile.new(csv_file.path, 'text/csv', true) }

        perform_enqueued_jobs
        expect(response).to have_http_status(:created)
        expect(Product.count).to eq 1
        expect(Product.first.upc).to eq(csv_record.second)
      end
    end
  end
end
