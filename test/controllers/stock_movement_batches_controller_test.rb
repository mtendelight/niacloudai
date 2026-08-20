require "test_helper"

class StockMovementBatchesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @stock_movement_batch = stock_movement_batches(:one)
  end

  test "should get index" do
    get stock_movement_batches_url
    assert_response :success
  end

  test "should get new" do
    get new_stock_movement_batch_url
    assert_response :success
  end

  test "should create stock_movement_batch" do
    assert_difference("StockMovementBatch.count") do
      post stock_movement_batches_url, params: { stock_movement_batch: { from_branch: @stock_movement_batch.from_branch, movement_date: @stock_movement_batch.movement_date, movement_type: @stock_movement_batch.movement_type, note: @stock_movement_batch.note, source_type: @stock_movement_batch.source_type, status: @stock_movement_batch.status, supplier_name: @stock_movement_batch.supplier_name, to_branch: @stock_movement_batch.to_branch } }
    end

    assert_redirected_to stock_movement_batch_url(StockMovementBatch.last)
  end

  test "should show stock_movement_batch" do
    get stock_movement_batch_url(@stock_movement_batch)
    assert_response :success
  end

  test "should get edit" do
    get edit_stock_movement_batch_url(@stock_movement_batch)
    assert_response :success
  end

  test "should update stock_movement_batch" do
    patch stock_movement_batch_url(@stock_movement_batch), params: { stock_movement_batch: { from_branch: @stock_movement_batch.from_branch, movement_date: @stock_movement_batch.movement_date, movement_type: @stock_movement_batch.movement_type, note: @stock_movement_batch.note, source_type: @stock_movement_batch.source_type, status: @stock_movement_batch.status, supplier_name: @stock_movement_batch.supplier_name, to_branch: @stock_movement_batch.to_branch } }
    assert_redirected_to stock_movement_batch_url(@stock_movement_batch)
  end

  test "should destroy stock_movement_batch" do
    assert_difference("StockMovementBatch.count", -1) do
      delete stock_movement_batch_url(@stock_movement_batch)
    end

    assert_redirected_to stock_movement_batches_url
  end
end
