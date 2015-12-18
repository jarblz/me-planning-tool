class CreateProjectCountries < ActiveRecord::Migration
  def change
    create_table :project_countries do |t|
      t.integer :project_id, null: false
      t.integer :country_id, null: false
    end
  end
end
