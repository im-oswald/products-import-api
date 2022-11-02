json.categories @categories.each do |category|
  json.id                     category.id
  json.name                   category.name
  json.total_weight           category.products.sum(:weight)/100
  json.products category.products.each do |product|
    json.id                     product.id
    json.upc                    product.upc
    json.date                   product.import_date
    json.weight                 product.weight
    json.unit                   product.unit
  end
end
