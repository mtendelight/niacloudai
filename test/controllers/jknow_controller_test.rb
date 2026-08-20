require "test_helper"

class JknowControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get jknow_index_url
    assert_response :success
  end
end
