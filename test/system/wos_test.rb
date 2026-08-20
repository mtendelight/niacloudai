require "application_system_test_case"

class WosTest < ApplicationSystemTestCase
  setup do
    @wo = wos(:one)
  end

  test "visiting the index" do
    visit wos_url
    assert_selector "h1", text: "Wos"
  end

  test "should create wo" do
    visit wos_url
    click_on "New wo"

    fill_in "Details of executor", with: @wo.Details_of_executor
    fill_in "End time", with: @wo.end_time
    fill_in "Nature", with: @wo.nature
    fill_in "Number", with: @wo.number
    fill_in "Rollback plan", with: @wo.rollback_plan
    fill_in "Services to be affected", with: @wo.services_to_be_affected
    fill_in "Start time", with: @wo.start_time
    fill_in "Status", with: @wo.status
    fill_in "Subject", with: @wo.subject
    fill_in "Work details", with: @wo.work_details
    fill_in "Work objective", with: @wo.work_objective
    click_on "Create Wo"

    assert_text "Wo was successfully created"
    click_on "Back"
  end

  test "should update Wo" do
    visit wo_url(@wo)
    click_on "Edit this wo", match: :first

    fill_in "Details of executor", with: @wo.Details_of_executor
    fill_in "End time", with: @wo.end_time
    fill_in "Nature", with: @wo.nature
    fill_in "Number", with: @wo.number
    fill_in "Rollback plan", with: @wo.rollback_plan
    fill_in "Services to be affected", with: @wo.services_to_be_affected
    fill_in "Start time", with: @wo.start_time
    fill_in "Status", with: @wo.status
    fill_in "Subject", with: @wo.subject
    fill_in "Work details", with: @wo.work_details
    fill_in "Work objective", with: @wo.work_objective
    click_on "Update Wo"

    assert_text "Wo was successfully updated"
    click_on "Back"
  end

  test "should destroy Wo" do
    visit wo_url(@wo)
    click_on "Destroy this wo", match: :first

    assert_text "Wo was successfully destroyed"
  end
end
