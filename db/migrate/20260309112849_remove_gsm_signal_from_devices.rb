class RemoveGsmSignalFromDevices < ActiveRecord::Migration[7.2]
  def change
    remove_column :devices, :gsm_signal, :integer
  end
end
