require "test_helper"

class JknowsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get jknows_index_url
    assert_response :success
  end
end
