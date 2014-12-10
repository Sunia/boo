class AddFriendCreditToClient < ActiveRecord::Migration
  def change
    add_column :clients, :friend_credit, :integer, :default => 1
  end
end
