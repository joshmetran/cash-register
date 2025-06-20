class CreateProducts < ActiveRecord::Migration[8.0]
  def change
    create_table :products do |t|
      t.string :code
      t.string :name
      t.decimal :price, precision: 16, scale: 2, default: 0
      t.boolean :is_buy_one_take_one
      t.boolean :can_bulk_purchase
      t.integer :min_bulk_purchase
      t.decimal :bulk_purchase_price, precision: 16, scale: 2, default: 0

      t.timestamps
    end
  end
end
