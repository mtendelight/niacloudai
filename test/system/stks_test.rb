require "application_system_test_case"

class StksTest < ApplicationSystemTestCase
  setup do
    @stk = stks(:one)
  end

  test "visiting the index" do
    visit stks_url
    assert_selector "h1", text: "Stks"
  end

  test "should create stk" do
    visit stks_url
    click_on "New stk"

    fill_in "Amount", with: @stk.amount
    fill_in "Modified at", with: @stk.modified_at
    fill_in "Phone number", with: @stk.phone_number
    click_on "Create Stk"

    assert_text "Stk was successfully created"
    click_on "Back"
  end

  test "should update Stk" do
    visit stk_url(@stk)
    click_on "Edit this stk", match: :first

    fill_in "Amount", with: @stk.amount
    fill_in "Modified at", with: @stk.modified_at.to_s
    fill_in "Phone number", with: @stk.phone_number
    click_on "Update Stk"

    assert_text "Stk was successfully updated"
    click_on "Back"
  end

  test "should destroy Stk" do
    visit stk_url(@stk)
    click_on "Destroy this stk", match: :first

    assert_text "Stk was successfully destroyed"
  end
end
