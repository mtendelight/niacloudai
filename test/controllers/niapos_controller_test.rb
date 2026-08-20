require "test_helper"

class NiaposControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get niapos_index_url
    assert_response :success
  end
end
