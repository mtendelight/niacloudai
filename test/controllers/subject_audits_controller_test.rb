require "test_helper"

class SubjectAuditsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get subject_audits_index_url
    assert_response :success
  end
end
