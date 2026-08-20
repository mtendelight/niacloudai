require "test_helper"

class MroadmapControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get mroadmap_index_url
    assert_response :success
  end
end
