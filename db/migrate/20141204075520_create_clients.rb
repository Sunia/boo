class CreateClients < ActiveRecord::Migration
  def change
    create_table :clients do |t|
       t.string :name
       t.string :nick_name
       t.string :gender
       t.boolean :status, :default => false
       t.string :contact_number

      t.timestamps
    end
  end
end


#name, nick name, gender, status(boolean), contact_number, country, admin 