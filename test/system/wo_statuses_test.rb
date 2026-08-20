require "application_system_test_case"

class WoStatusesTest < ApplicationSystemTestCase
  setup do
    @wo_status = wo_statuses(:one)
  end

  test "visiting the index" do
    visit wo_statuses_url
    assert_selector "h1", text: "Wo statuses"
  end

  test "should create wo status" do
    visit wo_statuses_url
    click_on "New wo status"

    fill_in "Name", with: @wo_status.name
    click_on "Create Wo status"

    assert_text "Wo status was successfully created"
    click_on "Back"
  end

  test "should update Wo status" do
    visit wo_status_url(@wo_status)
    click_on "Edit this wo status", match: :first

    fill_in "Name", with: @wo_status.name
    click_on "Update Wo status"

    assert_text "Wo status was successfully updated"
    click_on "Back"
  end

  test "should destroy Wo status" do
    visit wo_status_url(@wo_status)
    click_on "Destroy this wo status", match: :first

    assert_text "Wo status was successfully destroyed"
  end
end
