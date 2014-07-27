class CreateGroups < ActiveRecord::Migration
  def change
    create_table :pyrite_groups do |t|
      t.string :name
      t.integer :size
      t.integer :studies_id

      t.timestamps
    end
  end

end
