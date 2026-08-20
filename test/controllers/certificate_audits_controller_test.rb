require "test_helper"

class CertificateAuditsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get certificate_audits_index_url
    assert_response :success
  end
end
