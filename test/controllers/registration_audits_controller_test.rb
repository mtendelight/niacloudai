require "test_helper"

class RegistrationAuditsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get registration_audits_index_url
    assert_response :success
  end
end
