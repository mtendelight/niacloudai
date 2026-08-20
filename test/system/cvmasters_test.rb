require "application_system_test_case"

class CvmastersTest < ApplicationSystemTestCase
  setup do
    @cvmaster = cvmasters(:one)
  end

  test "visiting the index" do
    visit cvmasters_url
    assert_selector "h1", text: "Cvmasters"
  end

  test "should create cvmaster" do
    visit cvmasters_url
    click_on "New cvmaster"

    fill_in "Eight", with: @cvmaster.eight
    fill_in "Five", with: @cvmaster.five
    fill_in "Four", with: @cvmaster.four
    fill_in "One", with: @cvmaster.one
    fill_in "Position", with: @cvmaster.position
    fill_in "Resume", with: @cvmaster.resume
    fill_in "Seven", with: @cvmaster.seven
    fill_in "Shortlist", with: @cvmaster.shortlist_id
    fill_in "Six", with: @cvmaster.six
    fill_in "Three", with: @cvmaster.three
    fill_in "Two", with: @cvmaster.two
    fill_in "Username", with: @cvmaster.username
    click_on "Create Cvmaster"

    assert_text "Cvmaster was successfully created"
    click_on "Back"
  end

  test "should update Cvmaster" do
    visit cvmaster_url(@cvmaster)
    click_on "Edit this cvmaster", match: :first

    fill_in "Eight", with: @cvmaster.eight
    fill_in "Five", with: @cvmaster.five
    fill_in "Four", with: @cvmaster.four
    fill_in "One", with: @cvmaster.one
    fill_in "Position", with: @cvmaster.position
    fill_in "Resume", with: @cvmaster.resume
    fill_in "Seven", with: @cvmaster.seven
    fill_in "Shortlist", with: @cvmaster.shortlist_id
    fill_in "Six", with: @cvmaster.six
    fill_in "Three", with: @cvmaster.three
    fill_in "Two", with: @cvmaster.two
    fill_in "Username", with: @cvmaster.username
    click_on "Update Cvmaster"

    assert_text "Cvmaster was successfully updated"
    click_on "Back"
  end

  test "should destroy Cvmaster" do
    visit cvmaster_url(@cvmaster)
    click_on "Destroy this cvmaster", match: :first

    assert_text "Cvmaster was successfully destroyed"
  end
end
