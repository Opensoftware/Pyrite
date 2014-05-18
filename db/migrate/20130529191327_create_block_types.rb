class CreateBlockTypes < ActiveRecord::Migration
  def change
    create_table :pyrite_block_types do |t|
      t.string :name
      t.text :description
      t.string :short_name
      t.string :color

      t.timestamps
    end
  end
end
