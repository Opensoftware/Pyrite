class AddNewColumnToPlan < ActiveRecord::Migration
  def self.up
    add_column :plans, :wazneod, :date
    add_column :plans, :waznedo, :date
  end

  def self.down
    remove_column :plans, :waznedo
    remove_column :plans, :wazneod
  end
end
