class ModifyFriendDetails < ActiveRecord::Migration
  def change
    remove_column :friends, :contact_number
    remove_column :friends, :friend_name
    add_column :friends, :friend_id, :integer
  end
end
