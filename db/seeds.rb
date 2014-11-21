parsed = JSON.parse(File.read("db/the_iconic_data_feed.json"))

Item.destroy_all
Category.destroy_all

Category.create(:name => 'male')
Category.create(:name => 'female')
Category.create(:name => 'unisex')

parsed.each do |item|

  new_item = Item.new
  new_item.merchant_id = item["MerchantId"]
  new_item.sku = item["SKU"]
  new_item.name = item["Name"]
  new_item.merchant_url = item["Url"]
  new_item.price = item["Price"]
  new_item.price_sale = item["PriceSale"]
  new_item.brand = item["Brand"]
  new_item.color = item["Colour"]
  new_item.gender = item["Gender"]
  new_item.keywords = item["Keywords"]
  new_item.image_url50 = item["Image50"]
  new_item.image_url400 = item["Image400"]
  new_item.active = true


  category_s = item["Category"]
  categories_array = category_s.split(' > ')
  gender = item["Gender"]
  gender_id = Category.find_by(:name => gender).id
  parent_id = Category.find_by(:name => gender).id

  categories_array.each do |category|
    if Category.find(gender_id).descendants.where(:name => category).empty?
        new_category = Category.create(:name => category, :parent => Category.find(parent_id))
        parent_id = new_category.id
    else
        existing = Category.find(gender_id).descendants.where(:name => category)
        parent_id = existing.first.id
    end
  end

  new_item.category_id = parent_id
  new_item.save

end







