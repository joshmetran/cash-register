class CreateProducts < ActiveRecord::Migration[8.0]
  def change
    create_table :products do |t|
      t.string :code
      t.string :name
      t.decimal :price
      t.boolean :is_buy_one_take_one
      t.boolean :can_bulk_purchase
      t.integer :min_bulk_purchase
      t.decimal :bulk_purchase_price

      t.timestamps
    end
  end
end
