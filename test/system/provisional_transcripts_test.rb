require "application_system_test_case"

class ProvisionalTranscriptsTest < ApplicationSystemTestCase
  setup do
    @provisional_transcript = provisional_transcripts(:one)
  end

  test "visiting the index" do
    visit provisional_transcripts_url
    assert_selector "h1", text: "Provisional transcripts"
  end

  test "should create provisional transcript" do
    visit provisional_transcripts_url
    click_on "New provisional transcript"

    fill_in "Gpa", with: @provisional_transcript.gpa
    fill_in "Student", with: @provisional_transcript.student_id
    fill_in "Term", with: @provisional_transcript.term
    click_on "Create Provisional transcript"

    assert_text "Provisional transcript was successfully created"
    click_on "Back"
  end

  test "should update Provisional transcript" do
    visit provisional_transcript_url(@provisional_transcript)
    click_on "Edit this provisional transcript", match: :first

    fill_in "Gpa", with: @provisional_transcript.gpa
    fill_in "Student", with: @provisional_transcript.student_id
    fill_in "Term", with: @provisional_transcript.term
    click_on "Update Provisional transcript"

    assert_text "Provisional transcript was successfully updated"
    click_on "Back"
  end

  test "should destroy Provisional transcript" do
    visit provisional_transcript_url(@provisional_transcript)
    click_on "Destroy this provisional transcript", match: :first

    assert_text "Provisional transcript was successfully destroyed"
  end
end
