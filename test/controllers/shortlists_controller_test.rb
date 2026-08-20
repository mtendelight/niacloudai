require "test_helper"

class ShortlistsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @shortlist = shortlists(:one)
  end

  test "should get index" do
    get shortlists_url
    assert_response :success
  end

  test "should get new" do
    get new_shortlist_url
    assert_response :success
  end

  test "should create shortlist" do
    assert_difference("Shortlist.count") do
      post shortlists_url, params: { shortlist: { approve: @shortlist.approve, position: @shortlist.position, resume: @shortlist.resume, username: @shortlist.username } }
    end

    assert_redirected_to shortlist_url(Shortlist.last)
  end

  test "should show shortlist" do
    get shortlist_url(@shortlist)
    assert_response :success
  end

  test "should get edit" do
    get edit_shortlist_url(@shortlist)
    assert_response :success
  end

  test "should update shortlist" do
    patch shortlist_url(@shortlist), params: { shortlist: { approve: @shortlist.approve, position: @shortlist.position, resume: @shortlist.resume, username: @shortlist.username } }
    assert_redirected_to shortlist_url(@shortlist)
  end

  test "should destroy shortlist" do
    assert_difference("Shortlist.count", -1) do
      delete shortlist_url(@shortlist)
    end

    assert_redirected_to shortlists_url
  end
end
