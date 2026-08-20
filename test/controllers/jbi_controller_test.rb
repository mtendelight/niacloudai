require "test_helper"

class JbiControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get jbi_index_url
    assert_response :success
  end
end
