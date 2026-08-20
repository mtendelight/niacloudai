require "test_helper"

class RegistrationxesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @registrationx = registrationxes(:one)
  end

  test "should get index" do
    get registrationxes_url
    assert_response :success
  end

  test "should get new" do
    get new_registrationx_url
    assert_response :success
  end

  test "should create registrationx" do
    assert_difference("Registrationx.count") do
      post registrationxes_url, params: { registrationx: { registration_id: @registrationx.registration_id, semester: @registrationx.semester, student_id: @registrationx.student_id, subject_id: @registrationx.subject_id, unit_code: @registrationx.unit_code, unit_id: @registrationx.unit_id, year: @registrationx.year } }
    end

    assert_redirected_to registrationx_url(Registrationx.last)
  end

  test "should show registrationx" do
    get registrationx_url(@registrationx)
    assert_response :success
  end

  test "should get edit" do
    get edit_registrationx_url(@registrationx)
    assert_response :success
  end

  test "should update registrationx" do
    patch registrationx_url(@registrationx), params: { registrationx: { registration_id: @registrationx.registration_id, semester: @registrationx.semester, student_id: @registrationx.student_id, subject_id: @registrationx.subject_id, unit_code: @registrationx.unit_code, unit_id: @registrationx.unit_id, year: @registrationx.year } }
    assert_redirected_to registrationx_url(@registrationx)
  end

  test "should destroy registrationx" do
    assert_difference("Registrationx.count", -1) do
      delete registrationx_url(@registrationx)
    end

    assert_redirected_to registrationxes_url
  end
end
