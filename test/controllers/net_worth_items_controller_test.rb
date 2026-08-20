require "test_helper"

class NetWorthItemsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @net_worth_item = net_worth_items(:one)
  end

  test "should get index" do
    get net_worth_items_url
    assert_response :success
  end

  test "should get new" do
    get new_net_worth_item_url
    assert_response :success
  end

  test "should create net_worth_item" do
    assert_difference("NetWorthItem.count") do
      post net_worth_items_url, params: { net_worth_item: { item_type: @net_worth_item.item_type, name: @net_worth_item.name, user_id: @net_worth_item.user_id, value: @net_worth_item.value } }
    end

    assert_redirected_to net_worth_item_url(NetWorthItem.last)
  end

  test "should show net_worth_item" do
    get net_worth_item_url(@net_worth_item)
    assert_response :success
  end

  test "should get edit" do
    get edit_net_worth_item_url(@net_worth_item)
    assert_response :success
  end

  test "should update net_worth_item" do
    patch net_worth_item_url(@net_worth_item), params: { net_worth_item: { item_type: @net_worth_item.item_type, name: @net_worth_item.name, user_id: @net_worth_item.user_id, value: @net_worth_item.value } }
    assert_redirected_to net_worth_item_url(@net_worth_item)
  end

  test "should destroy net_worth_item" do
    assert_difference("NetWorthItem.count", -1) do
      delete net_worth_item_url(@net_worth_item)
    end

    assert_redirected_to net_worth_items_url
  end
end
