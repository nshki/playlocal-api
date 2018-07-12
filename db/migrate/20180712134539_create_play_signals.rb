class CreatePlaySignals < ActiveRecord::Migration[5.2]
  def change
    create_table :play_signals do |t|
      t.string :message
      t.datetime :end_time
      t.float :lat
      t.float :lng
      t.integer :user_id
      t.boolean :published

      t.timestamps

      t.index :user_id
    end
  end
end
