class RemoveLastSeenAtFromDevices < ActiveRecord::Migration[7.2]
  def change
    remove_column :devices, :last_seen_at, :datetime
  end
end
