class AddNewTypeForSala < ActiveRecord::Migration
  def self.up
    change_column 'plans','sala', :string
  end

  def self.down
    change_column 'plans','sala', :integer
  end
end
