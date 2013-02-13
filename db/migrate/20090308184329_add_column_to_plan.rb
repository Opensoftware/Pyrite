class AddColumnToPlan < ActiveRecord::Migration
  def self.up
		add_column :plans, :plan_id, :integer, :null => false, :default => ""
  end

  def self.down
		remove_column :plans, :plan_id
  end
end
