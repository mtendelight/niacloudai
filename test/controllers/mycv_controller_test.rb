require "test_helper"

class MycvControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get mycv_index_url
    assert_response :success
  end
end
