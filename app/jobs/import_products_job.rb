# frozen_string_literal: true

class ImportProductsJob < ApplicationJob
  queue_as :default

  def perform(file)
    CsvImportService.new.call(file)
  end
end
