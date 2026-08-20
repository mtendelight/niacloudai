require "test_helper"

class MBookingsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @m_booking = m_bookings(:one)
  end

  test "should get index" do
    get m_bookings_url
    assert_response :success
  end

  test "should get new" do
    get new_m_booking_url
    assert_response :success
  end

  test "should create m_booking" do
    assert_difference("MBooking.count") do
      post m_bookings_url, params: { m_booking: { amount: @m_booking.amount, comments: @m_booking.comments, id_number: @m_booking.id_number, m_adventure_id: @m_booking.m_adventure_id, name: @m_booking.name, payment_status: @m_booking.payment_status, phone: @m_booking.phone } }
    end

    assert_redirected_to m_booking_url(MBooking.last)
  end

  test "should show m_booking" do
    get m_booking_url(@m_booking)
    assert_response :success
  end

  test "should get edit" do
    get edit_m_booking_url(@m_booking)
    assert_response :success
  end

  test "should update m_booking" do
    patch m_booking_url(@m_booking), params: { m_booking: { amount: @m_booking.amount, comments: @m_booking.comments, id_number: @m_booking.id_number, m_adventure_id: @m_booking.m_adventure_id, name: @m_booking.name, payment_status: @m_booking.payment_status, phone: @m_booking.phone } }
    assert_redirected_to m_booking_url(@m_booking)
  end

  test "should destroy m_booking" do
    assert_difference("MBooking.count", -1) do
      delete m_booking_url(@m_booking)
    end

    assert_redirected_to m_bookings_url
  end
end
