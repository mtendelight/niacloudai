require "test_helper"

class HandsonsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @handson = handsons(:one)
  end

  test "should get index" do
    get handsons_url
    assert_response :success
  end

  test "should get new" do
    get new_handson_url
    assert_response :success
  end

  test "should create handson" do
    assert_difference("Handson.count") do
      post handsons_url, params: { handson: { course_id: @handson.course_id, description: @handson.description, photo: @handson.photo, title: @handson.title, video: @handson.video } }
    end

    assert_redirected_to handson_url(Handson.last)
  end

  test "should show handson" do
    get handson_url(@handson)
    assert_response :success
  end

  test "should get edit" do
    get edit_handson_url(@handson)
    assert_response :success
  end

  test "should update handson" do
    patch handson_url(@handson), params: { handson: { course_id: @handson.course_id, description: @handson.description, photo: @handson.photo, title: @handson.title, video: @handson.video } }
    assert_redirected_to handson_url(@handson)
  end

  test "should destroy handson" do
    assert_difference("Handson.count", -1) do
      delete handson_url(@handson)
    end

    assert_redirected_to handsons_url
  end
end
