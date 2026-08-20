require "application_system_test_case"

class NaturesTest < ApplicationSystemTestCase
  setup do
    @nature = natures(:one)
  end

  test "visiting the index" do
    visit natures_url
    assert_selector "h1", text: "Natures"
  end

  test "should create nature" do
    visit natures_url
    click_on "New nature"

    fill_in "Name", with: @nature.name
    click_on "Create Nature"

    assert_text "Nature was successfully created"
    click_on "Back"
  end

  test "should update Nature" do
    visit nature_url(@nature)
    click_on "Edit this nature", match: :first

    fill_in "Name", with: @nature.name
    click_on "Update Nature"

    assert_text "Nature was successfully updated"
    click_on "Back"
  end

  test "should destroy Nature" do
    visit nature_url(@nature)
    click_on "Destroy this nature", match: :first

    assert_text "Nature was successfully destroyed"
  end
end
