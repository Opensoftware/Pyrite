class CreateGroups < ActiveRecord::Migration
  def change
    create_table :pyrite_groups do |t|
      t.string :name
      t.integer :size
      t.boolean :part_time, :default => false

      t.timestamps
    end
  end

end
