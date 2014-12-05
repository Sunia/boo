class CreateFriends < ActiveRecord::Migration
  def change
    create_table :friends do |t|
       t.integer :client_id
       t.string :contact_number
       t.string :friend_name
      t.timestamps
    end
  end
end
