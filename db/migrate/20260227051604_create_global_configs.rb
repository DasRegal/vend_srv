class CreateGlobalConfigs < ActiveRecord::Migration[7.2]
  def change
    create_table :global_configs do |t|
      t.string :token

      t.timestamps
    end
  end
end
