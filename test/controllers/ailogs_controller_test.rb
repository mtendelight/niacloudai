require "test_helper"

class AilogsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get ailogs_index_url
    assert_response :success
  end
end
