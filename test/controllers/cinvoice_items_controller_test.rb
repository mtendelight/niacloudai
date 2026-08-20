require "test_helper"

class CinvoiceItemsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @cinvoice_item = cinvoice_items(:one)
  end

  test "should get index" do
    get cinvoice_items_url
    assert_response :success
  end

  test "should get new" do
    get new_cinvoice_item_url
    assert_response :success
  end

  test "should create cinvoice_item" do
    assert_difference("CinvoiceItem.count") do
      post cinvoice_items_url, params: { cinvoice_item: { cinvoice_id: @cinvoice_item.cinvoice_id, description: @cinvoice_item.description, quantity: @cinvoice_item.quantity, total: @cinvoice_item.total, unit_price: @cinvoice_item.unit_price } }
    end

    assert_redirected_to cinvoice_item_url(CinvoiceItem.last)
  end

  test "should show cinvoice_item" do
    get cinvoice_item_url(@cinvoice_item)
    assert_response :success
  end

  test "should get edit" do
    get edit_cinvoice_item_url(@cinvoice_item)
    assert_response :success
  end

  test "should update cinvoice_item" do
    patch cinvoice_item_url(@cinvoice_item), params: { cinvoice_item: { cinvoice_id: @cinvoice_item.cinvoice_id, description: @cinvoice_item.description, quantity: @cinvoice_item.quantity, total: @cinvoice_item.total, unit_price: @cinvoice_item.unit_price } }
    assert_redirected_to cinvoice_item_url(@cinvoice_item)
  end

  test "should destroy cinvoice_item" do
    assert_difference("CinvoiceItem.count", -1) do
      delete cinvoice_item_url(@cinvoice_item)
    end

    assert_redirected_to cinvoice_items_url
  end
end
