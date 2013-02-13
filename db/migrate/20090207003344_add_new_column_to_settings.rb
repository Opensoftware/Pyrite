class AddNewColumnToSettings < ActiveRecord::Migration
  def self.up
    add_column :settings, :plan_to_edit, :integer
  end

  def self.down
		remove_column :settings, :plan_to_edit
  end
end
