class CreateOrders < ActiveRecord::Migration[8.0]
  def change
    create_table :orders do |t|
      t.string :invoice_no
      t.decimal :total_price, precision: 16, scale: 2, default: 0

      t.timestamps
    end
  end
end
