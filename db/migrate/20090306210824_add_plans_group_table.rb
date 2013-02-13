class AddPlansGroupTable < ActiveRecord::Migration
  def self.up
    create_table :groups_plans, :id => false, :force => true  do |t|
      t.integer :group_id, :plan_id
      t.timestamps
    end
  end

  def self.down
		drop_table :groups_plans
  end
end
