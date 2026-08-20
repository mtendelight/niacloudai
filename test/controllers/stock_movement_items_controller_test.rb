require "test_helper"

class StockMovementItemsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @stock_movement_item = stock_movement_items(:one)
  end

  test "should get index" do
    get stock_movement_items_url
    assert_response :success
  end

  test "should get new" do
    get new_stock_movement_item_url
    assert_response :success
  end

  test "should create stock_movement_item" do
    assert_difference("StockMovementItem.count") do
      post stock_movement_items_url, params: { stock_movement_item: { bale_name: @stock_movement_item.bale_name, qty: @stock_movement_item.qty, stock_movement_batch_id: @stock_movement_item.stock_movement_batch_id, unit_price: @stock_movement_item.unit_price } }
    end

    assert_redirected_to stock_movement_item_url(StockMovementItem.last)
  end

  test "should show stock_movement_item" do
    get stock_movement_item_url(@stock_movement_item)
    assert_response :success
  end

  test "should get edit" do
    get edit_stock_movement_item_url(@stock_movement_item)
    assert_response :success
  end

  test "should update stock_movement_item" do
    patch stock_movement_item_url(@stock_movement_item), params: { stock_movement_item: { bale_name: @stock_movement_item.bale_name, qty: @stock_movement_item.qty, stock_movement_batch_id: @stock_movement_item.stock_movement_batch_id, unit_price: @stock_movement_item.unit_price } }
    assert_redirected_to stock_movement_item_url(@stock_movement_item)
  end

  test "should destroy stock_movement_item" do
    assert_difference("StockMovementItem.count", -1) do
      delete stock_movement_item_url(@stock_movement_item)
    end

    assert_redirected_to stock_movement_items_url
  end
end
