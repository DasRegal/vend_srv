class AddGsmSignalToDevices < ActiveRecord::Migration[7.2]
  def change
    add_column :devices, :gsm_signal, :integer
  end
end
