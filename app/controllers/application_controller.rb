class ApplicationController < ActionController::Base
  skip_before_action :verify_authenticity_token
  after_action :remove_extra_headers


  include ActionController::HttpAuthentication::Basic::ControllerMethods
  include ActionController::MimeResponds
  include ActionController::Helpers

  before_action :authenticate_device!

  def authenticate_device!
    token = request.headers['X-Device-Token']
    sn_or_id = params[:serial_number] || params[:id]

    device = Device.find_by(serial_number: sn_or_id) || Device.find_by(id: sn_or_id)

    if device && token.present? && token == device.effective_token
      return
    end

    admin_auth = authenticate_with_http_basic do |username, password|
      username == ENV['ADMIN_USERNAME'] && password == ENV['ADMIN_PASSWORD']
    end

    return if admin_auth

    request_http_basic_authentication("Application") and return
  end

  private

  def remove_extra_headers
    response.headers.delete('Vary')
  end
end
