require "test_helper"

class HeartbeatsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @heartbeat = heartbeats(:one)
  end

  test "should get index" do
    get heartbeats_url, as: :json
    assert_response :success
  end

  test "should create heartbeat" do
    assert_difference("Heartbeat.count") do
      post heartbeats_url, params: { heartbeat: { last_seen_at: @heartbeat.last_seen_at, serial_number: @heartbeat.serial_number } }, as: :json
    end

    assert_response :created
  end

  test "should show heartbeat" do
    get heartbeat_url(@heartbeat), as: :json
    assert_response :success
  end

  test "should update heartbeat" do
    patch heartbeat_url(@heartbeat), params: { heartbeat: { last_seen_at: @heartbeat.last_seen_at, serial_number: @heartbeat.serial_number } }, as: :json
    assert_response :success
  end

  test "should destroy heartbeat" do
    assert_difference("Heartbeat.count", -1) do
      delete heartbeat_url(@heartbeat), as: :json
    end

    assert_response :no_content
  end
end
