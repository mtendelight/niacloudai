require "test_helper"

class McontactsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @mcontact = mcontacts(:one)
  end

  test "should get index" do
    get mcontacts_url
    assert_response :success
  end

  test "should get new" do
    get new_mcontact_url
    assert_response :success
  end

  test "should create mcontact" do
    assert_difference("Mcontact.count") do
      post mcontacts_url, params: { mcontact: { company: @mcontact.company, email: @mcontact.email, name: @mcontact.name, notes: @mcontact.notes, phone: @mcontact.phone, position: @mcontact.position, user_id: @mcontact.user_id } }
    end

    assert_redirected_to mcontact_url(Mcontact.last)
  end

  test "should show mcontact" do
    get mcontact_url(@mcontact)
    assert_response :success
  end

  test "should get edit" do
    get edit_mcontact_url(@mcontact)
    assert_response :success
  end

  test "should update mcontact" do
    patch mcontact_url(@mcontact), params: { mcontact: { company: @mcontact.company, email: @mcontact.email, name: @mcontact.name, notes: @mcontact.notes, phone: @mcontact.phone, position: @mcontact.position, user_id: @mcontact.user_id } }
    assert_redirected_to mcontact_url(@mcontact)
  end

  test "should destroy mcontact" do
    assert_difference("Mcontact.count", -1) do
      delete mcontact_url(@mcontact)
    end

    assert_redirected_to mcontacts_url
  end
end
