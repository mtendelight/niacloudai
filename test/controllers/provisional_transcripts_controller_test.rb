require "test_helper"

class ProvisionalTranscriptsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @provisional_transcript = provisional_transcripts(:one)
  end

  test "should get index" do
    get provisional_transcripts_url
    assert_response :success
  end

  test "should get new" do
    get new_provisional_transcript_url
    assert_response :success
  end

  test "should create provisional_transcript" do
    assert_difference("ProvisionalTranscript.count") do
      post provisional_transcripts_url, params: { provisional_transcript: { gpa: @provisional_transcript.gpa, student_id: @provisional_transcript.student_id, term: @provisional_transcript.term } }
    end

    assert_redirected_to provisional_transcript_url(ProvisionalTranscript.last)
  end

  test "should show provisional_transcript" do
    get provisional_transcript_url(@provisional_transcript)
    assert_response :success
  end

  test "should get edit" do
    get edit_provisional_transcript_url(@provisional_transcript)
    assert_response :success
  end

  test "should update provisional_transcript" do
    patch provisional_transcript_url(@provisional_transcript), params: { provisional_transcript: { gpa: @provisional_transcript.gpa, student_id: @provisional_transcript.student_id, term: @provisional_transcript.term } }
    assert_redirected_to provisional_transcript_url(@provisional_transcript)
  end

  test "should destroy provisional_transcript" do
    assert_difference("ProvisionalTranscript.count", -1) do
      delete provisional_transcript_url(@provisional_transcript)
    end

    assert_redirected_to provisional_transcripts_url
  end
end
