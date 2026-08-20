require "test_helper"

class MTimeOffsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @m_time_off = m_time_offs(:one)
  end

  test "should get index" do
    get m_time_offs_url
    assert_response :success
  end

  test "should get new" do
    get new_m_time_off_url
    assert_response :success
  end

  test "should create m_time_off" do
    assert_difference("MTimeOff.count") do
      post m_time_offs_url, params: { m_time_off: { end_date: @m_time_off.end_date, leave_type: @m_time_off.leave_type, m_employee_id: @m_time_off.m_employee_id, reason: @m_time_off.reason, start_date: @m_time_off.start_date, status: @m_time_off.status } }
    end

    assert_redirected_to m_time_off_url(MTimeOff.last)
  end

  test "should show m_time_off" do
    get m_time_off_url(@m_time_off)
    assert_response :success
  end

  test "should get edit" do
    get edit_m_time_off_url(@m_time_off)
    assert_response :success
  end

  test "should update m_time_off" do
    patch m_time_off_url(@m_time_off), params: { m_time_off: { end_date: @m_time_off.end_date, leave_type: @m_time_off.leave_type, m_employee_id: @m_time_off.m_employee_id, reason: @m_time_off.reason, start_date: @m_time_off.start_date, status: @m_time_off.status } }
    assert_redirected_to m_time_off_url(@m_time_off)
  end

  test "should destroy m_time_off" do
    assert_difference("MTimeOff.count", -1) do
      delete m_time_off_url(@m_time_off)
    end

    assert_redirected_to m_time_offs_url
  end
end
