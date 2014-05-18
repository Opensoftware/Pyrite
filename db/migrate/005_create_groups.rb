class CreateGroups < ActiveRecord::Migration
  def change
    create_table :pyrite_groups do |t|
      t.string :name

      t.timestamps
    end
  end

end
