require "application_system_test_case"

class StkpushesTest < ApplicationSystemTestCase
  setup do
    @stkpush = stkpushes(:one)
  end

  test "visiting the index" do
    visit stkpushes_url
    assert_selector "h1", text: "Stkpushes"
  end

  test "should create stkpush" do
    visit stkpushes_url
    click_on "New stkpush"

    fill_in "Amount", with: @stkpush.amount
    fill_in "Modified at", with: @stkpush.modified_at
    fill_in "Phone number", with: @stkpush.phone_number
    click_on "Create Stkpush"

    assert_text "Stkpush was successfully created"
    click_on "Back"
  end

  test "should update Stkpush" do
    visit stkpush_url(@stkpush)
    click_on "Edit this stkpush", match: :first

    fill_in "Amount", with: @stkpush.amount
    fill_in "Modified at", with: @stkpush.modified_at.to_s
    fill_in "Phone number", with: @stkpush.phone_number
    click_on "Update Stkpush"

    assert_text "Stkpush was successfully updated"
    click_on "Back"
  end

  test "should destroy Stkpush" do
    visit stkpush_url(@stkpush)
    click_on "Destroy this stkpush", match: :first

    assert_text "Stkpush was successfully destroyed"
  end
end
