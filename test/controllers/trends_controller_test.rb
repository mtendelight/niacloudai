require "test_helper"

class TrendsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @trend = trends(:one)
  end

  test "should get index" do
    get trends_url
    assert_response :success
  end

  test "should get new" do
    get new_trend_url
    assert_response :success
  end

  test "should create trend" do
    assert_difference("Trend.count") do
      post trends_url, params: { trend: { category: @trend.category, image_url: @trend.image_url, last_seen_at: @trend.last_seen_at, name: @trend.name, platform: @trend.platform, popularity: @trend.popularity, source_url: @trend.source_url } }
    end

    assert_redirected_to trend_url(Trend.last)
  end

  test "should show trend" do
    get trend_url(@trend)
    assert_response :success
  end

  test "should get edit" do
    get edit_trend_url(@trend)
    assert_response :success
  end

  test "should update trend" do
    patch trend_url(@trend), params: { trend: { category: @trend.category, image_url: @trend.image_url, last_seen_at: @trend.last_seen_at, name: @trend.name, platform: @trend.platform, popularity: @trend.popularity, source_url: @trend.source_url } }
    assert_redirected_to trend_url(@trend)
  end

  test "should destroy trend" do
    assert_difference("Trend.count", -1) do
      delete trend_url(@trend)
    end

    assert_redirected_to trends_url
  end
end
