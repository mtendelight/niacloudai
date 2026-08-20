require "application_system_test_case"

class ClassroomsTest < ApplicationSystemTestCase
  setup do
    @classroom = classrooms(:one)
  end

  test "visiting the index" do
    visit classrooms_url
    assert_selector "h1", text: "Classrooms"
  end

  test "should create classroom" do
    visit classrooms_url
    click_on "New classroom"

    fill_in "Assessment method", with: @classroom.assessment_method
    fill_in "Branch", with: @classroom.branch_id
    fill_in "Contact information", with: @classroom.contact_information
    fill_in "Course level", with: @classroom.course_level_id
    fill_in "Course name", with: @classroom.course_name
    fill_in "Description", with: @classroom.description
    fill_in "Duration", with: @classroom.duration
    fill_in "End date", with: @classroom.end_date
    fill_in "Enrollment deadline", with: @classroom.enrollment_deadline
    fill_in "Fee allocation", with: @classroom.fee_allocation_id
    fill_in "Fees", with: @classroom.fees
    fill_in "Material required", with: @classroom.material_required
    fill_in "Mode", with: @classroom.mode_id
    fill_in "Schedule", with: @classroom.schedule_id
    fill_in "Start date", with: @classroom.start_date
    click_on "Create Classroom"

    assert_text "Classroom was successfully created"
    click_on "Back"
  end

  test "should update Classroom" do
    visit classroom_url(@classroom)
    click_on "Edit this classroom", match: :first

    fill_in "Assessment method", with: @classroom.assessment_method
    fill_in "Branch", with: @classroom.branch_id
    fill_in "Contact information", with: @classroom.contact_information
    fill_in "Course level", with: @classroom.course_level_id
    fill_in "Course name", with: @classroom.course_name
    fill_in "Description", with: @classroom.description
    fill_in "Duration", with: @classroom.duration
    fill_in "End date", with: @classroom.end_date
    fill_in "Enrollment deadline", with: @classroom.enrollment_deadline
    fill_in "Fee allocation", with: @classroom.fee_allocation_id
    fill_in "Fees", with: @classroom.fees
    fill_in "Material required", with: @classroom.material_required
    fill_in "Mode", with: @classroom.mode_id
    fill_in "Schedule", with: @classroom.schedule_id
    fill_in "Start date", with: @classroom.start_date
    click_on "Update Classroom"

    assert_text "Classroom was successfully updated"
    click_on "Back"
  end

  test "should destroy Classroom" do
    visit classroom_url(@classroom)
    click_on "Destroy this classroom", match: :first

    assert_text "Classroom was successfully destroyed"
  end
end
