require "test_helper"

class MybrandControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get mybrand_index_url
    assert_response :success
  end
end
