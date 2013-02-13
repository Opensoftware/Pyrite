class CreateSettings < ActiveRecord::Migration
  def self.up
    create_table :settings do |t|
			t.column 'current_plan', :integer	

      t.timestamps
    end
  end

  def self.down
    drop_table :settings
  end
end
