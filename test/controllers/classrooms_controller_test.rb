require "test_helper"

class ClassroomsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @classroom = classrooms(:one)
  end

  test "should get index" do
    get classrooms_url
    assert_response :success
  end

  test "should get new" do
    get new_classroom_url
    assert_response :success
  end

  test "should create classroom" do
    assert_difference("Classroom.count") do
      post classrooms_url, params: { classroom: { assessment_method: @classroom.assessment_method, branch_id: @classroom.branch_id, contact_information: @classroom.contact_information, course_level_id: @classroom.course_level_id, course_name: @classroom.course_name, description: @classroom.description, duration: @classroom.duration, end_date: @classroom.end_date, enrollment_deadline: @classroom.enrollment_deadline, fee_allocation_id: @classroom.fee_allocation_id, fees: @classroom.fees, material_required: @classroom.material_required, mode_id: @classroom.mode_id, schedule_id: @classroom.schedule_id, start_date: @classroom.start_date } }
    end

    assert_redirected_to classroom_url(Classroom.last)
  end

  test "should show classroom" do
    get classroom_url(@classroom)
    assert_response :success
  end

  test "should get edit" do
    get edit_classroom_url(@classroom)
    assert_response :success
  end

  test "should update classroom" do
    patch classroom_url(@classroom), params: { classroom: { assessment_method: @classroom.assessment_method, branch_id: @classroom.branch_id, contact_information: @classroom.contact_information, course_level_id: @classroom.course_level_id, course_name: @classroom.course_name, description: @classroom.description, duration: @classroom.duration, end_date: @classroom.end_date, enrollment_deadline: @classroom.enrollment_deadline, fee_allocation_id: @classroom.fee_allocation_id, fees: @classroom.fees, material_required: @classroom.material_required, mode_id: @classroom.mode_id, schedule_id: @classroom.schedule_id, start_date: @classroom.start_date } }
    assert_redirected_to classroom_url(@classroom)
  end

  test "should destroy classroom" do
    assert_difference("Classroom.count", -1) do
      delete classroom_url(@classroom)
    end

    assert_redirected_to classrooms_url
  end
end
