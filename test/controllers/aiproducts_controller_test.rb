require "test_helper"

class AiproductsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get aiproducts_index_url
    assert_response :success
  end
end
