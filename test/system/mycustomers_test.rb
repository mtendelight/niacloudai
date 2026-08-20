require "application_system_test_case"

class MycustomersTest < ApplicationSystemTestCase
  setup do
    @mycustomer = mycustomers(:one)
  end

  test "visiting the index" do
    visit mycustomers_url
    assert_selector "h1", text: "Mycustomers"
  end

  test "should create mycustomer" do
    visit mycustomers_url
    click_on "New mycustomer"

    fill_in "Email", with: @mycustomer.email
    fill_in "Fullname", with: @mycustomer.fullname
    fill_in "Phone number", with: @mycustomer.phone_number
    click_on "Create Mycustomer"

    assert_text "Mycustomer was successfully created"
    click_on "Back"
  end

  test "should update Mycustomer" do
    visit mycustomer_url(@mycustomer)
    click_on "Edit this mycustomer", match: :first

    fill_in "Email", with: @mycustomer.email
    fill_in "Fullname", with: @mycustomer.fullname
    fill_in "Phone number", with: @mycustomer.phone_number
    click_on "Update Mycustomer"

    assert_text "Mycustomer was successfully updated"
    click_on "Back"
  end

  test "should destroy Mycustomer" do
    visit mycustomer_url(@mycustomer)
    click_on "Destroy this mycustomer", match: :first

    assert_text "Mycustomer was successfully destroyed"
  end
end
