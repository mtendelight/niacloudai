require "test_helper"

class ContactusControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get contactus_index_url
    assert_response :success
  end
end
