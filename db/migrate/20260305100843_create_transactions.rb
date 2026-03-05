class CreateTransactions < ActiveRecord::Migration[7.2]
  def change
    create_table :transactions do |t|
      t.string :serial_number
      t.integer :item
      t.integer :item_price
      t.integer :cash_balance
      t.integer :cashless_balance
      t.integer :balance
      t.boolean :is_dispensed

      t.timestamps
    end
  end
end
