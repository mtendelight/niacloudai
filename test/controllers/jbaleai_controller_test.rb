require "test_helper"

class JbaleaiControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get jbaleai_index_url
    assert_response :success
  end
end
