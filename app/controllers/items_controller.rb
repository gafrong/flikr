class ItemsController < ApplicationController

  before_action :authenticate, :except => [:index] 

  def index
    @items = Item.all

    offset = rand(Item.count)
    @rand_record = Item.offset(offset).first.id
  end

  def show
    @user = current_user
    @item = Item.find(params[:id])

    @next_item = next_item

     # refreshes item if a color is clicked
    @item = next_item if params[:color]

  end

  def create_history

    user = current_user

    new_history = History.new
    new_history.user_id = user.id
    new_history.item_id = params['item_id']
    new_history.liked = if params['liked'] == 'true'
                          true
                        else
                          false
                        end
    new_history.in_wishlist = if params['liked'] == 'true'
                          true
                        else
                          false
                        end
    new_history.clicked_through = params['clicked_through']
    new_history.save

    # for all gender with color
    if params['category_1'] == "" && params['color'] != nil
      next_item_path = "/items/category/#{params[:gender]}/all?&color=#{params[:color]}"
    # if category_1 is nil, route leads to "view all *gender*"
    elsif params['category_1'] == ""
      next_item_path = "/items/category/#{params[:gender]}/all"
    # if category_1 has a value, route leads to "View *gender* *category*"
    else params['category_1']
      next_item_path = "/items/category/#{params[:gender]}/#{params[:category_1]}/view?&color=#{params[:color]}"
    end
    # gets rid of the spaces on the url
    next_item_path = URI.encode(next_item_path)
    # redirect to a url that contains gender and cat1
    redirect_to next_item_path

  end

  def create_history_from_buy
    user = current_user

    new_history = History.new
    new_history.user_id = user.id
    new_history.item_id = params['item_id']
    new_history.liked = if params['liked'] == 'true'
                          true
                        else
                          false
                        end
    new_history.in_wishlist = if params['liked'] == 'true'
                          true
                        else
                          false
                        end
    new_history.clicked_through = params['clicked_through']
    new_history.save

    redirect_to new_history.item.merchant_url

  end

  def edit_history
    user = current_user
    current_history_item = user.histories.where(:item_id => params['item_id']).first
    current_history_item.clicked_through = params['clicked_through']
    current_history_item.save

    redirect_to current_history_item.item.merchant_url
  end

  def delete_from_wishlist
    user = current_user
    current_history_item = user.histories.where(:item_id => params['item_id']).first
    current_history_item.in_wishlist = false
    current_history_item.save

    redirect_to user_wishlist_path
  end

  def details
    @item = Item.where(:id => params['id']).first
  end

  def convert_top_level_name(gender)
    category = gender.downcase

      if category == ("womens" || "Womens")
        @category = "female"
        @name = "Womens"
      elsif category == ("mens" || "Mens")
        @category = "male"
        @name = "Mens"
      end

    @category
  end

  def top_category
    @gender_old = params[:gender]

    @gender = convert_top_level_name(@gender_old)

    id = Category.where(name: @gender).first.id

    @children = Category.find(id).children

    render '/items/category/index.html.erb'
  end

  def category_1
    @gender_old = params[:gender]
    @gender = convert_top_level_name(@gender_old)
    @cat1 = params[:category_1]

    @children = Category.find_by(name: @gender).descendants.find_by(name: @cat1).children

    render '/items/category/index.html.erb'
  end

  def category_1_view

    gender_old = params[:gender]
    @gender = convert_top_level_name(gender_old)
    @user = current_user
    @color = params['color']

    @items_cat = Category.find_by(name: @gender).descendants.where("lower(name) = ?", params[:category_1])

    # gets the original category id to include with all descending ids
    item_id = @items_cat.first.id
    cat_ids = Category.find(@items_cat.first.id).descendants.pluck(:id)
    cat_ids << item_id
    @items = Item.where(category_id: cat_ids)

    # takes only items that are not in the user's history, and NO perfumes (cat id 148)
    @items = @items.where.not(:id => @user.histories.pluck(:item_id), :category_id => 148)

    @next_item = next_item

    # refreshes item if a color is clicked
    if @color != nil 
      @next_item = next_item
    end

    render '/items/category/show.html.erb'
  end

  def category_all
    @user = current_user

    @category = params[:category]
    @gender = params[:gender]
    @color = params[:color]

    case @category || @gender
      when 'womens'
        @category == 'womens'
        @items = Item.where('gender=? OR gender=?', 'female', 'unisex')
        @item = @items.sample
      when 'mens'
        @items = Item.where('gender=? OR gender=?', 'male', 'unisex')
        @item = @items.sample
    end

    @next_item = next_item

    # refreshes item if a color is clicked
    if @color != nil 
      @next_item = next_item
    end

    render '/items/category/show.html.erb'

  end


  private

  def next_item
  # Determines what will be shown next

    # if a first-time user (no history yet)
    if @user.histories.count < 20

        if @color == nil
          @next_item = @items.sample
        else #there's a color params (whether "" or color)
            if @color == ""
              @next_item = @items.sample
            else
              @next_item = @items.where(:color => params['color']).sample
            end
      end


    # if user has history record
    else

      liked_items = @user.histories.where(:liked => true)

      brands_liked = liked_items.each_with_object(Hash.new(0)) { |item,counts| counts[item.item.brand] += 1 }


      counts = []
      # gets all the item counts and adds to 'counts' array
      brands_liked.each do |pair|
        counts << pair[1]
      end
      #finds out the two highest counts from the 'counts' array
      highest_counts = counts.sort.uniq

      if highest_counts.length > 1
        highest_counts = highest_counts[-2..-1]
      else
        highest_counts
      end

      #makes an array of the brand or category that has the highest counts
      fave_brands = brands_liked.map{|item, count| item if highest_counts.include?count }.compact


      # if there's a color selected
      if @color != nil
        if @color == ""
          @items
        else
          @items = @items.where(:color => @color)
        end
      end

      # gives two options: 1. three random items, 2. one item from a favourite brand
      items_to_show = [@items.sample, @items.sample, @items.sample, @items.where(brand: fave_brands.sample).sample ]

      #chooses randomly from the 'items_to_show' options
      @sampled = items_to_show.sample

      #sets the @next item -- chooses another item (from the items_to_show) if @sampled is a nil
      if @sampled != nil
        @next_item = @sampled
      else
        @next_item = items_to_show.first
      end

    end

  end

end