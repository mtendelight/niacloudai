require "test_helper"

class JmcustomerpaymentsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get jmcustomerpayments_index_url
    assert_response :success
  end
end
