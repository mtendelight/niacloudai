require "test_helper"

class KnowledgeFeedbacksControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get knowledge_feedbacks_index_url
    assert_response :success
  end

  test "should get show" do
    get knowledge_feedbacks_show_url
    assert_response :success
  end
end
