class AddGsmSignalToHeartbeats < ActiveRecord::Migration[7.2]
  def change
    add_column :heartbeats, :gsm_signal, :integer
  end
end
