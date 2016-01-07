class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :lead
      t.string :contact_email
      t.string :contact_phone
      t.string :description
      t.datetime :funding_start
      t.datetime :funding_end
      t.string :donor
      t.string :primary_indicator_name
      t.integer :primary_indicator_value
      t.string :secondary_indicator_name
      t.integer :secondary_indicator_value
      t.timestamps
    end
  end
end
