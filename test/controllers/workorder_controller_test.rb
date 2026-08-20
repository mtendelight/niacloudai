require "test_helper"

class WorkorderControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get workorder_index_url
    assert_response :success
  end
end
