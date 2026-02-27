class ApplicationController < ActionController::Base
  skip_before_action :verify_authenticity_token

  include ActionController::HttpAuthentication::Basic::ControllerMethods
  include ActionController::MimeResponds
  include ActionController::Helpers

  before_action :authenticate_device!

  def authenticate_device!
    token = request.headers['X-Device-Token']
   
    device = Device.find_by(serial_number: params[:id])
  
    if device && token.present? && token == device.effective_token
      return
    end

    authenticate_or_request_with_http_basic("Application") do |username, password|
      username == ENV['ADMIN_USERNAME'] && password == ENV['ADMIN_PASSWORD']
    end
  end

  private
end
