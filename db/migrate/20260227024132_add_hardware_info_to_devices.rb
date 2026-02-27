class AddHardwareInfoToDevices < ActiveRecord::Migration[7.2]
  def change
    add_column :devices, :board_name, :string
    add_column :devices, :hw_rev, :string
    add_column :devices, :fw_ver, :string
    add_column :devices, :git_hash, :string
    add_column :devices, :billbox_sn, :string
    add_column :devices, :billbox_name, :string
    add_column :devices, :coinbox_sn, :string
    add_column :devices, :coinbox_name, :string
    add_column :devices, :cashless_sn, :string
    add_column :devices, :cashless_name, :string
  end
end
