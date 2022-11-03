# frozen_string_literal: true

class CategorySerializer < ActiveModel::Serializer
  attributes :id, :name, :total_weight, :products

  def total_weight
    object.products.map(&:convert_to_kilograms).sum.round(2)
  end

  def products
    object.products.limit(2).map do |product|
      {
        id: product.id,
        upc: product.upc,
        import_date: product.import_date,
        weight: product.weight,
        unit: product.unit
      }
    end
  end
end
