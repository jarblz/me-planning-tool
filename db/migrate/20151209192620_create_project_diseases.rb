class CreateProjectDiseases < ActiveRecord::Migration
  def change
    create_table :project_diseases do |t|
      t.integer :project_id, null: false
      t.integer :disease_id, null: false
    end
  end
end
