class CreateRequests < ActiveRecord::Migration
  def change
    create_table :requests do |t|
       t.integer :sender_id
       t.integer :receiver_id
       t.boolean :rqst_status, :default => false
       t.timestamps
    end
  end
end
