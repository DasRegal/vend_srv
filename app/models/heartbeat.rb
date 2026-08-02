class Heartbeat < ApplicationRecord
  def signal_status
    return "Нет сигнала" if gsm_signal.nil? || gsm_signal == 99
    return "Отличный" if gsm_signal > 25
    return "Хороший" if gsm_signal > 15
    "Слабый"
  end
end
