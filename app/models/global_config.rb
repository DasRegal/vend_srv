class GlobalConfig < ApplicationRecord
  validates :token, length: { is: 32 }, presence: true
  validate :only_one_row, on: :create

  def self.instance
    first_or_create!(token: SecureRandom.alphanumeric(32))
  end

  private

  def only_one_row
    if GlobalConfig.count > 0
      errors.add(:base, "Может существовать только одна запись глобальных настроек")
    end
  end
end
