class CreateProducts < ActiveRecord::Migration[6.1]
  def change
    create_table :products do |t|
      t.string :upc, null: false
      t.datetime :import_date, null: false
      t.float :weight, null: false, default: 0.0
      t.string :unit, null: false
      t.references :category, null: false, foreign_key: true

      t.timestamps
    end
  end
end
