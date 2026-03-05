class Transaction < ApplicationRecord
  # Связь через кастомный ключ
  belongs_to :device, primary_key: :serial_number, foreign_key: :serial_number, optional: true

  # Валидации для защиты данных
  validates :item, inclusion: 1..255
  validates :item_price, :cash_balance, :cashless_balance, :balance, inclusion: 0..65535
end
