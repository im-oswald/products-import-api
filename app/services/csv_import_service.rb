# frozen_string_literal: true

require 'csv'

class CsvImportService
  HEADERS = { 'date': 0, 'product_id': 1, 'weight': 2, 'unit': 3 }.with_indifferent_access.freeze

  def call(csv_path)
    CSV.foreach(csv_path, headers: true) do |row|
      category = Category.find_or_create_by({ name: row[HEADERS['product_id']].split('-').first })
      upc = row[HEADERS['product_id']]
      import_date = row[HEADERS['date']].to_datetime
      unit = row[HEADERS['unit']]
      weight = row[HEADERS['weight']].to_f

      category.products.create(upc: upc, import_date: import_date, unit: unit, weight: weight)
    end
  rescue StandardError
    Rails.logger.error "EXCEPTION: #{e}"
  end
end
