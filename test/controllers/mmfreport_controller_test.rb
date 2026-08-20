require "test_helper"

class MmfreportControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get mmfreport_index_url
    assert_response :success
  end
end
