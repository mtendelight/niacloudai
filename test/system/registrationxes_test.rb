require "application_system_test_case"

class RegistrationxesTest < ApplicationSystemTestCase
  setup do
    @registrationx = registrationxes(:one)
  end

  test "visiting the index" do
    visit registrationxes_url
    assert_selector "h1", text: "Registrationxes"
  end

  test "should create registrationx" do
    visit registrationxes_url
    click_on "New registrationx"

    fill_in "Registration", with: @registrationx.registration_id
    fill_in "Semester", with: @registrationx.semester
    fill_in "Student", with: @registrationx.student_id
    fill_in "Subject", with: @registrationx.subject_id
    fill_in "Unit code", with: @registrationx.unit_code
    fill_in "Unit", with: @registrationx.unit_id
    fill_in "Year", with: @registrationx.year
    click_on "Create Registrationx"

    assert_text "Registrationx was successfully created"
    click_on "Back"
  end

  test "should update Registrationx" do
    visit registrationx_url(@registrationx)
    click_on "Edit this registrationx", match: :first

    fill_in "Registration", with: @registrationx.registration_id
    fill_in "Semester", with: @registrationx.semester
    fill_in "Student", with: @registrationx.student_id
    fill_in "Subject", with: @registrationx.subject_id
    fill_in "Unit code", with: @registrationx.unit_code
    fill_in "Unit", with: @registrationx.unit_id
    fill_in "Year", with: @registrationx.year
    click_on "Update Registrationx"

    assert_text "Registrationx was successfully updated"
    click_on "Back"
  end

  test "should destroy Registrationx" do
    visit registrationx_url(@registrationx)
    click_on "Destroy this registrationx", match: :first

    assert_text "Registrationx was successfully destroyed"
  end
end
