require "application_system_test_case"

class EquitypaysTest < ApplicationSystemTestCase
  setup do
    @equitypay = equitypays(:one)
  end

  test "visiting the index" do
    visit equitypays_url
    assert_selector "h1", text: "Equitypays"
  end

  test "should create equitypay" do
    visit equitypays_url
    click_on "New equitypay"

    fill_in "Bill amount", with: @equitypay.bill_amount
    fill_in "Bill currency", with: @equitypay.bill_currency
    fill_in "Bill reference", with: @equitypay.bill_reference
    fill_in "Payer account", with: @equitypay.payer_account
    fill_in "Payer name", with: @equitypay.payer_name
    click_on "Create Equitypay"

    assert_text "Equitypay was successfully created"
    click_on "Back"
  end

  test "should update Equitypay" do
    visit equitypay_url(@equitypay)
    click_on "Edit this equitypay", match: :first

    fill_in "Bill amount", with: @equitypay.bill_amount
    fill_in "Bill currency", with: @equitypay.bill_currency
    fill_in "Bill reference", with: @equitypay.bill_reference
    fill_in "Payer account", with: @equitypay.payer_account
    fill_in "Payer name", with: @equitypay.payer_name
    click_on "Update Equitypay"

    assert_text "Equitypay was successfully updated"
    click_on "Back"
  end

  test "should destroy Equitypay" do
    visit equitypay_url(@equitypay)
    click_on "Destroy this equitypay", match: :first

    assert_text "Equitypay was successfully destroyed"
  end
end
