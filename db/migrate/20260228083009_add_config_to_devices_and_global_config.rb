class AddConfigToDevicesAndGlobalConfig < ActiveRecord::Migration[7.2]
  def change
    add_column :devices, :config, :jsonb, default: {}
    add_column :global_configs, :config, :jsonb, default: {}
  end
end
