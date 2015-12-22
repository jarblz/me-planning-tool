class AddDefaultAdminToUser < ActiveRecord::Migration
  def change
    change_column :users, :admin, :boolean, null: false, default: true
  end
end
