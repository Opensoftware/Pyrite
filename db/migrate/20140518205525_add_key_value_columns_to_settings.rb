class AddKeyValueColumnsToSettings < ActiveRecord::Migration
  def change
    add_column :settings, :key, :string
    add_column :settings, :value, :string

    add_index(:settings, :key, unique: true)
  end
end
