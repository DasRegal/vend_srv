class Device < ApplicationRecord
  has_one :heartbeat, primary_key: :serial_number, foreign_key: :serial_number, dependent: :destroy

  # После создания устройства в базе, создаем для него Heartbeat
  after_create :create_associated_heartbeat

  # Ищем запись в Heartbeat с таким же серийником
  def heartbeat
    Heartbeat.find_by(serial_number: self.serial_number)
  end

  def status_info
    hb = heartbeat

    return { text: "Новое устройство", class: "label-secondary" } if hb.last_seen_at.nil?

    if hb.last_seen_at > 1.minute.ago
      { text: "Активен", class: "label-success" }
    else
      { text: "Не активен", class: "label-danger" }
    end
  end

  def effective_token
    use_global_token ? GlobalConfig.instance.token : access_token
  end

  private

  def create_associated_heartbeat
    # Создаем запись, если её еще нет (на всякий случай)
    Heartbeat.find_or_create_by(serial_number: self.serial_number)
  end
end
