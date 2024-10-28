class CreateOperatingHours < ActiveRecord::Migration[7.2]
  def change
    create_table :operating_hours do |t|
      t.string :day
      t.time :open_time
      t.time :close_time
      t.boolean :closed
      t.references :restaurant, null: false, foreign_key: true

      t.timestamps
    end
  end
end
