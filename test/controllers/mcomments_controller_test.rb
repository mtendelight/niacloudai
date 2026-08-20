require "test_helper"

class McommentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @mcomment = mcomments(:one)
  end

  test "should get index" do
    get mcomments_url
    assert_response :success
  end

  test "should get new" do
    get new_mcomment_url
    assert_response :success
  end

  test "should create mcomment" do
    assert_difference("Mcomment.count") do
      post mcomments_url, params: { mcomment: { content: @mcomment.content, project_id: @mcomment.project_id, user_id: @mcomment.user_id } }
    end

    assert_redirected_to mcomment_url(Mcomment.last)
  end

  test "should show mcomment" do
    get mcomment_url(@mcomment)
    assert_response :success
  end

  test "should get edit" do
    get edit_mcomment_url(@mcomment)
    assert_response :success
  end

  test "should update mcomment" do
    patch mcomment_url(@mcomment), params: { mcomment: { content: @mcomment.content, project_id: @mcomment.project_id, user_id: @mcomment.user_id } }
    assert_redirected_to mcomment_url(@mcomment)
  end

  test "should destroy mcomment" do
    assert_difference("Mcomment.count", -1) do
      delete mcomment_url(@mcomment)
    end

    assert_redirected_to mcomments_url
  end
end
