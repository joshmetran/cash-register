class AddActualQtyToOrderDetails < ActiveRecord::Migration[8.0]
  def change
    add_column :order_details, :actual_qty, :integer
  end
end
