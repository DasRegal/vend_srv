class CreateHeartbeats < ActiveRecord::Migration[7.2]
  def change
    create_table :heartbeats do |t|
      t.string :serial_number
      t.datetime :last_seen_at

      t.timestamps
    end
    add_index :heartbeats, :serial_number, unique: true
  end
end
