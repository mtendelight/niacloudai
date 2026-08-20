require "application_system_test_case"

class OfficialTranscriptsTest < ApplicationSystemTestCase
  setup do
    @official_transcript = official_transcripts(:one)
  end

  test "visiting the index" do
    visit official_transcripts_url
    assert_selector "h1", text: "Official transcripts"
  end

  test "should create official transcript" do
    visit official_transcripts_url
    click_on "New official transcript"

    fill_in "Content", with: @official_transcript.content
    fill_in "Student", with: @official_transcript.student_id
    fill_in "Term", with: @official_transcript.term
    click_on "Create Official transcript"

    assert_text "Official transcript was successfully created"
    click_on "Back"
  end

  test "should update Official transcript" do
    visit official_transcript_url(@official_transcript)
    click_on "Edit this official transcript", match: :first

    fill_in "Content", with: @official_transcript.content
    fill_in "Student", with: @official_transcript.student_id
    fill_in "Term", with: @official_transcript.term
    click_on "Update Official transcript"

    assert_text "Official transcript was successfully updated"
    click_on "Back"
  end

  test "should destroy Official transcript" do
    visit official_transcript_url(@official_transcript)
    click_on "Destroy this official transcript", match: :first

    assert_text "Official transcript was successfully destroyed"
  end
end
