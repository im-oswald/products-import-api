class ImportProductsJob < ApplicationJob
  queue_as :default

  def perform(file)
    ImportProducts::CsvImportService.new.call(file)
  end
end
