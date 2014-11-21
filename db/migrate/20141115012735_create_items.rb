class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
    	t.integer :merchant_id
      t.string :sku
      t.string :name
      t.integer :category_id
      t.text :merchant_url
      t.decimal :price, :precision => 10, :scale => 2
      t.decimal :price_sale
      t.string :brand
      t.string :color
      t.string :gender
      t.text :keywords
      t.text :image_url50
      t.text :image_url400
      t.integer :rating
      t.boolean :active

      t.timestamps
    end
  end
end
