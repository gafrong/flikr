class ChangePriceFromDecimalToString < ActiveRecord::Migration
  def change
  	change_column :items, :price, :string
  	change_column :items, :price_sale, :string
  end
end
