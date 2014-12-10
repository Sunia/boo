class RemoveColumnFromRequests < ActiveRecord::Migration
  def change
    remove_column :requests, :receiver_id
  end
end
