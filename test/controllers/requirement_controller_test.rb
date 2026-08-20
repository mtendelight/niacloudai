require "test_helper"

class RequirementControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get requirement_index_url
    assert_response :success
  end
end
