class CreateHistories < ActiveRecord::Migration
  def change
    create_table :histories do |t|
    		t.integer :user_id
    		t.integer :item_id
    		t.boolean :liked
    		t.boolean :in_wishlist
    		t.boolean :clicked_through
      t.timestamps
    end
  end
end
