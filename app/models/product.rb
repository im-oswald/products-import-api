# frozen_string_literal: true

class Product < ApplicationRecord
  belongs_to :category

  validates :unit, :import_date, :upc, presence: true
  validates :weight, numericality: { greater_than_or_equal_to: 0 }

  def convert_to_kilograms
    UnitConverterService.call(weight, unit, :kg)
  end
end
