class AddImgToProducts < ActiveRecord::Migration[8.0]
  def change
    add_column :products, :img_url, :string
  end
end
