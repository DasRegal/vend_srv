class AddLastSeenAtToDevices < ActiveRecord::Migration[7.2]
  def change
    add_column :devices, :last_seen_at, :datetime
  end
end
