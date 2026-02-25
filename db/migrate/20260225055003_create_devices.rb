class CreateDevices < ActiveRecord::Migration[7.2]
  def change
    create_table :devices do |t|
      t.string :serial_number
      t.string :address
      t.string :description
      t.string :status

      t.timestamps
    end
    add_index :devices, :serial_number, unique: true
  end
end
