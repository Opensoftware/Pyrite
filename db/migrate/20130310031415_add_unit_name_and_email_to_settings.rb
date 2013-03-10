class AddUnitNameAndEmailToSettings < ActiveRecord::Migration
  def change
    add_column :settings, :unit_name, :string
    add_column :settings, :email_contact, :string
  end
end
