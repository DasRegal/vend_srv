class ApplicationController < ActionController::Base
  skip_before_action :verify_authenticity_token

  include ActionController::HttpAuthentication::Basic::ControllerMethods
  include ActionController::MimeResponds
  include ActionController::Helpers

  before_action :authenticate_device!

  def authenticate_device!
    token = request.headers['X-Device-Token']
    
    return if token.present? && token == ENV['DEVICE_API_TOKEN']

    authenticate_or_request_with_http_basic("Application") do |username, password|
      username == ENV['ADMIN_USERNAME'] && password == ENV['ADMIN_PASSWORD']
    end
  end

  private
end
