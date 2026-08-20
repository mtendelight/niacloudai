require "test_helper"

class BrandVisibilitiesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @brand_visibility = brand_visibilities(:one)
  end

  test "should get index" do
    get brand_visibilities_url
    assert_response :success
  end

  test "should get new" do
    get new_brand_visibility_url
    assert_response :success
  end

  test "should create brand_visibility" do
    assert_difference("BrandVisibility.count") do
      post brand_visibilities_url, params: { brand_visibility: { channel: @brand_visibility.channel, date: @brand_visibility.date, description: @brand_visibility.description, reach: @brand_visibility.reach, status: @brand_visibility.status, title: @brand_visibility.title } }
    end

    assert_redirected_to brand_visibility_url(BrandVisibility.last)
  end

  test "should show brand_visibility" do
    get brand_visibility_url(@brand_visibility)
    assert_response :success
  end

  test "should get edit" do
    get edit_brand_visibility_url(@brand_visibility)
    assert_response :success
  end

  test "should update brand_visibility" do
    patch brand_visibility_url(@brand_visibility), params: { brand_visibility: { channel: @brand_visibility.channel, date: @brand_visibility.date, description: @brand_visibility.description, reach: @brand_visibility.reach, status: @brand_visibility.status, title: @brand_visibility.title } }
    assert_redirected_to brand_visibility_url(@brand_visibility)
  end

  test "should destroy brand_visibility" do
    assert_difference("BrandVisibility.count", -1) do
      delete brand_visibility_url(@brand_visibility)
    end

    assert_redirected_to brand_visibilities_url
  end
end
