class AddNewTable < ActiveRecord::Migration
  def self.up
    add_column 'groups', 'rok', :integer
    add_column 'groups', 'kurs', :string
    add_column 'groups', 'kierunek', :string
    add_column 'groups', 'grupa', :integer
    add_column 'groups', 'podgrupa', :integer
  end

  def self.down
    remove_column 'groups', 'rok'
    remove_column 'groups', 'kurs'
    remove_column 'groups', 'kierunek'
    remove_column 'groups', 'grupa'
    remove_column 'groups', 'podgrupa'
  end
end
