class CreateDepartments < ActiveRecord::Migration
  def self.up
    create_table :departments do |t|
      t.column "nazwa", :string
      t.column "nazwa_f", :string
      t.column "wydzial" , :string
      t.timestamps
    end
  end

  def self.down
    drop_table :departments
  end
end
