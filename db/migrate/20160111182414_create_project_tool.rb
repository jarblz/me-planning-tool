class CreateProjectTool < ActiveRecord::Migration
  def change
    create_table :project_tools do |t|
      t.integer :project_id
      t.string :name
      t.attachment :attachment
    end
  end
end
