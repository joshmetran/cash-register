class CreateOrderDetails < ActiveRecord::Migration[8.0]
  def change
    create_table :order_details do |t|
      t.references :order, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true
      t.decimal :price, precision: 16, scale: 2, default: 0
      t.integer :qty
      t.decimal :total_price, precision: 16, scale: 2, default: 0
      t.string :remarks

      t.timestamps
    end
  end
end
