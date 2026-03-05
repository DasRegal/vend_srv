class Device < ApplicationRecord
  has_one :heartbeat, primary_key: :serial_number, foreign_key: :serial_number, dependent: :destroy

  validate :config_must_be_valid_json

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
    local = case self[:config]
          when String then JSON.parse(self[:config]) rescue {}
          when Hash   then self[:config]
          else {}
          end

    global_record = GlobalConfig.first
    global = global_record&.config.is_a?(Hash) ? global_record.config : {}

    defaults = {}

    final_config = defaults.deep_merge(global).deep_merge(local).deep_stringify_keys

  # ПРОВЕРКА: Если ключа "dispenser" нет вообще, создаем пустую структуру,
  # чтобы код ниже не падал
  final_config["dispenser"] ||= {}

  # ПРОВЕРКА: Безопасно заходим в "items"
  items = final_config.dig("dispenser", "items")

  if items.is_a?(Array)
    items.each do |item|
      # Используем ||= чтобы не затирать существующие значения
      item["price"]     ||= final_config.dig("dispenser", "default_price")
      item["timeout"]   ||= final_config.dig("dispenser", "default_timeout")
      item["twist_time"] ||= final_config.dig("dispenser", "default_twist_time")
      item["enable"] = false if item["enable"].nil?
    end
  end

    final_config
  end

  private

  def config_must_be_valid_json
    # Если данные уже пришли как Hash (Rails сам распарсил JSONB), то всё хорошо
    return if config.is_a?(Hash) || config.is_a?(Array) || config.nil?

    begin
      # Пытаемся распарсить строку, если она пришла в сыром виде
      JSON.parse(config) if config.is_a?(String)
    rescue JSON::ParserError => e
      errors.add(:config, "имеет неверный формат JSON: #{e.message}")
    end
  end

  def create_associated_heartbeat
    create_heartbeat(serial_number: self.serial_number) unless heartbeat
  end
end
