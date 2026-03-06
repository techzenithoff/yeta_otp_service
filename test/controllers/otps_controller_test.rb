require "test_helper"

class OtpsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @otp = otps(:one)
  end

  test "should get index" do
    get otps_url, as: :json
    assert_response :success
  end

  test "should create otp" do
    assert_difference('Otp.count') do
      post otps_url, params: { otp: {  } }, as: :json
    end

    assert_response 201
  end

  test "should show otp" do
    get otp_url(@otp), as: :json
    assert_response :success
  end

  test "should update otp" do
    patch otp_url(@otp), params: { otp: {  } }, as: :json
    assert_response 200
  end

  test "should destroy otp" do
    assert_difference('Otp.count', -1) do
      delete otp_url(@otp), as: :json
    end

    assert_response 204
  end
end
