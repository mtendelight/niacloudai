require "test_helper"

class OfficialTranscriptsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @official_transcript = official_transcripts(:one)
  end

  test "should get index" do
    get official_transcripts_url
    assert_response :success
  end

  test "should get new" do
    get new_official_transcript_url
    assert_response :success
  end

  test "should create official_transcript" do
    assert_difference("OfficialTranscript.count") do
      post official_transcripts_url, params: { official_transcript: { content: @official_transcript.content, student_id: @official_transcript.student_id, term: @official_transcript.term } }
    end

    assert_redirected_to official_transcript_url(OfficialTranscript.last)
  end

  test "should show official_transcript" do
    get official_transcript_url(@official_transcript)
    assert_response :success
  end

  test "should get edit" do
    get edit_official_transcript_url(@official_transcript)
    assert_response :success
  end

  test "should update official_transcript" do
    patch official_transcript_url(@official_transcript), params: { official_transcript: { content: @official_transcript.content, student_id: @official_transcript.student_id, term: @official_transcript.term } }
    assert_redirected_to official_transcript_url(@official_transcript)
  end

  test "should destroy official_transcript" do
    assert_difference("OfficialTranscript.count", -1) do
      delete official_transcript_url(@official_transcript)
    end

    assert_redirected_to official_transcripts_url
  end
end
