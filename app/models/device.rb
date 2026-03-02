class Device < ApplicationRecord
  has_one :heartbeat, primary_key: :serial_number, foreign_key: :serial_number, dependent: :destroy

  # После создания устройства в базе, создаем для него Heartbeat
  after_create :create_associated_heartbeat

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

  def merged_config
    local = self[:config] || {}
    global = GlobalConfig.first&.config || {}

    # 3. Дефолты из ТЗ
    defaults = {}

    # Глубокое слияние: Global поверх дефолтов, Local поверх Global
    final_config = defaults.deep_merge(global).deep_merge(local)

    # Обработка массива items (наложение дефолтов на каждый айтем)
    if final_config["dispenser"]["items"].is_a?(Array)
      final_config["dispenser"]["items"].each do |item|
        item["price"] ||= final_config["dispenser"]["default_price"]
        item["timeout"] ||= final_config["dispenser"]["default_timeout"]
        item["twist_time"] ||= final_config["dispenser"]["default_twist_time"]
        item["enable"] = false if item["enable"].nil?
      end
    end

    final_config
  end

#  def full_config
#    # Базовые значения, которые ты указал
#    defaults = {
#      dispenser: {
#        default_price: 150,
#        default_timeout: 7000,
#        default_twist_time: 0,
#        items: []
#      },
#      cashless: { always_idle: false, vmc_level: 2 },
#      server: { ip: "95.81.100.8", port: 3000 }
#    }
#
#    global_json = (GlobalConfig.first&.config || {}).to_h.deep_symbolize_keys
#    device_json = (self.config || {}).to_h.deep_symbolize_keys
#
#    # Склеиваем всё вместе
#    defaults.deep_merge(global_json).deep_merge(device_json)
#  end

  private

  def create_associated_heartbeat
    create_heartbeat(serial_number: self.serial_number) unless heartbeat
  end
end
