class CreateGroups < ActiveRecord::Migration
  def self.up
    create_table :groups do |t|
    t.column "nazwa", :string
    t.column "liczba", :int 

      t.timestamps
    end
  end

  def self.down
    drop_table :groups
  end
end
