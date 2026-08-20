require "test_helper"

class MarkAuditsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get mark_audits_index_url
    assert_response :success
  end
end
