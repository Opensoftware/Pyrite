class CreateBlockTypes < ActiveRecord::Migration
  def change
    create_table :block_types do |t|
      t.string :name
      t.text :description
      t.string :short_name

      t.timestamps
    end
  end
end
