class Category < ActiveRecord::Base
  has_many :items
  has_ancestry
end
