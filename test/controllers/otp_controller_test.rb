require "test_helper"

class OtpControllerTest < ActionDispatch::IntegrationTest
  test "should get setup" do
    get otp_setup_url
    assert_response :success
  end

  test "should get verify" do
    get otp_verify_url
    assert_response :success
  end

  test "should get enable" do
    get otp_enable_url
    assert_response :success
  end

  test "should get disable" do
    get otp_disable_url
    assert_response :success
  end
end
