class CreateBlockDates < ActiveRecord::Migration
  def change
    create_table :block_dates do |t|
      t.datetime :start_date
      t.datetime :end_date
      t.integer :block_id

      t.timestamps
    end
  end
end
