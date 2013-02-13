class CreateFreedays < ActiveRecord::Migration
  def self.up
    create_table :freedays do |t|
		t.column :start, :datetime
		t.column :stop, :datetime
		t.column :nazwa, :string

      t.timestamps
    end
  end

  def self.down
    drop_table :freedays
  end
end
