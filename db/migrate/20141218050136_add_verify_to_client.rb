class AddVerifyToClient < ActiveRecord::Migration
  def change
    add_column :clients, :code, :integer
  end
end
