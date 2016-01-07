class CreateGlobalIndicators < ActiveRecord::Migration
  def self.up
    create_table :global_indicators do |t|
      t.string :primary_indicator_name
      t.string :secondary_indicator_name
      t.timestamps
    end
  end

  def self.down
    drop_table :settings
  end
end
