require "application_system_test_case"

class HandsonsTest < ApplicationSystemTestCase
  setup do
    @handson = handsons(:one)
  end

  test "visiting the index" do
    visit handsons_url
    assert_selector "h1", text: "Handsons"
  end

  test "should create handson" do
    visit handsons_url
    click_on "New handson"

    fill_in "Course", with: @handson.course_id
    fill_in "Description", with: @handson.description
    fill_in "Photo", with: @handson.photo
    fill_in "Title", with: @handson.title
    fill_in "Video", with: @handson.video
    click_on "Create Handson"

    assert_text "Handson was successfully created"
    click_on "Back"
  end

  test "should update Handson" do
    visit handson_url(@handson)
    click_on "Edit this handson", match: :first

    fill_in "Course", with: @handson.course_id
    fill_in "Description", with: @handson.description
    fill_in "Photo", with: @handson.photo
    fill_in "Title", with: @handson.title
    fill_in "Video", with: @handson.video
    click_on "Update Handson"

    assert_text "Handson was successfully updated"
    click_on "Back"
  end

  test "should destroy Handson" do
    visit handson_url(@handson)
    click_on "Destroy this handson", match: :first

    assert_text "Handson was successfully destroyed"
  end
end
