require "application_system_test_case"

class EnrollmentsTest < ApplicationSystemTestCase
  setup do
    @enrollment = enrollments(:one)
  end

  test "visiting the index" do
    visit enrollments_url
    assert_selector "h1", text: "Enrollments"
  end

  test "should create enrollment" do
    visit enrollments_url
    click_on "New enrollment"

    fill_in "Alternative phone number", with: @enrollment.alternative_phone_number
    fill_in "Classroom", with: @enrollment.classroom_id
    fill_in "Email", with: @enrollment.email
    fill_in "Name", with: @enrollment.name
    fill_in "Phone number", with: @enrollment.phone_number
    click_on "Create Enrollment"

    assert_text "Enrollment was successfully created"
    click_on "Back"
  end

  test "should update Enrollment" do
    visit enrollment_url(@enrollment)
    click_on "Edit this enrollment", match: :first

    fill_in "Alternative phone number", with: @enrollment.alternative_phone_number
    fill_in "Classroom", with: @enrollment.classroom_id
    fill_in "Email", with: @enrollment.email
    fill_in "Name", with: @enrollment.name
    fill_in "Phone number", with: @enrollment.phone_number
    click_on "Update Enrollment"

    assert_text "Enrollment was successfully updated"
    click_on "Back"
  end

  test "should destroy Enrollment" do
    visit enrollment_url(@enrollment)
    click_on "Destroy this enrollment", match: :first

    assert_text "Enrollment was successfully destroyed"
  end
end
