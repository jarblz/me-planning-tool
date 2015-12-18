class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :lead
      t.string :contact_email
      t.string :contact_phone
      t.string :description
      t.datetime :funding_start
      t.datetime :funding_end
      t.float :total_funding
      t.string :donor
      t.integer :total_treated
      t.integer :total_trained
      t.timestamps
    end
  end
end
