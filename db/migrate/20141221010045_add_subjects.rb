class AddSubjects < ActiveRecord::Migration
  def change
    create_table :pyrite_subjects do |t|
      t.string :name
    end
  end
end
