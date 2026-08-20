require "test_helper"

class PosControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get pos_index_url
    assert_response :success
  end
end
