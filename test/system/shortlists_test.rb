require "application_system_test_case"

class ShortlistsTest < ApplicationSystemTestCase
  setup do
    @shortlist = shortlists(:one)
  end

  test "visiting the index" do
    visit shortlists_url
    assert_selector "h1", text: "Shortlists"
  end

  test "should create shortlist" do
    visit shortlists_url
    click_on "New shortlist"

    check "Approve" if @shortlist.approve
    fill_in "Position", with: @shortlist.position
    fill_in "Resume", with: @shortlist.resume
    fill_in "Username", with: @shortlist.username
    click_on "Create Shortlist"

    assert_text "Shortlist was successfully created"
    click_on "Back"
  end

  test "should update Shortlist" do
    visit shortlist_url(@shortlist)
    click_on "Edit this shortlist", match: :first

    check "Approve" if @shortlist.approve
    fill_in "Position", with: @shortlist.position
    fill_in "Resume", with: @shortlist.resume
    fill_in "Username", with: @shortlist.username
    click_on "Update Shortlist"

    assert_text "Shortlist was successfully updated"
    click_on "Back"
  end

  test "should destroy Shortlist" do
    visit shortlist_url(@shortlist)
    click_on "Destroy this shortlist", match: :first

    assert_text "Shortlist was successfully destroyed"
  end
end
