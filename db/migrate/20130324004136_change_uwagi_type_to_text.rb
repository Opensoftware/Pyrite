class ChangeUwagiTypeToText < ActiveRecord::Migration
  def up
    change_column :rooms, :uwagi, :text
  end

  def down
    change_column :rooms, :uwagi, :integer
  end
end
