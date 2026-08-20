require "test_helper"

class NiareportControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get niareport_index_url
    assert_response :success
  end
end
