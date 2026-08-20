require "test_helper"

class JmproductsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get jmproducts_index_url
    assert_response :success
  end
end
