class AddTokensToDevices < ActiveRecord::Migration[7.2]
  def change
    add_column :devices, :access_token, :string
    add_column :devices, :use_global_token, :boolean
  end
end
