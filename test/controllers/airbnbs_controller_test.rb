require "test_helper"

class AirbnbsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @airbnb = airbnbs(:one)
  end

  test "should get index" do
    get airbnbs_url
    assert_response :success
  end

  test "should get new" do
    get new_airbnb_url
    assert_response :success
  end

  test "should create airbnb" do
    assert_difference("Airbnb.count") do
      post airbnbs_url, params: { airbnb: { caretaker: @airbnb.caretaker, cleaner: @airbnb.cleaner, description: @airbnb.description, location_address: @airbnb.location_address, name: @airbnb.name, price: @airbnb.price, town: @airbnb.town } }
    end

    assert_redirected_to airbnb_url(Airbnb.last)
  end

  test "should show airbnb" do
    get airbnb_url(@airbnb)
    assert_response :success
  end

  test "should get edit" do
    get edit_airbnb_url(@airbnb)
    assert_response :success
  end

  test "should update airbnb" do
    patch airbnb_url(@airbnb), params: { airbnb: { caretaker: @airbnb.caretaker, cleaner: @airbnb.cleaner, description: @airbnb.description, location_address: @airbnb.location_address, name: @airbnb.name, price: @airbnb.price, town: @airbnb.town } }
    assert_redirected_to airbnb_url(@airbnb)
  end

  test "should destroy airbnb" do
    assert_difference("Airbnb.count", -1) do
      delete airbnb_url(@airbnb)
    end

    assert_redirected_to airbnbs_url
  end
end
