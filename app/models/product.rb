class Product < ApplicationRecord
  belongs_to :category
  # validates
  # scope

  def convert_to_kilograms
    # byebug if (!self.respond_to?(:UnitConverter))
    UnitConverter.call(self.weight, self.unit, :kg)
  end
end
