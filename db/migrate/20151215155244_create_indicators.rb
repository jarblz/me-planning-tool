class CreateIndicators < ActiveRecord::Migration
  def change
    create_table :indicators do |t|
      t.integer :project_id
      t.string :indicator_name
      t.string :indicator_value
      t.timestamps
    end
  end
end
