require "test_helper"

class TalentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @talent = talents(:one)
  end

  test "should get index" do
    get talents_url
    assert_response :success
  end

  test "should get new" do
    get new_talent_url
    assert_response :success
  end

  test "should create talent" do
    assert_difference("Talent.count") do
      post talents_url, params: { talent: { alt_phone: @talent.alt_phone, email: @talent.email, full_name: @talent.full_name, id_number: @talent.id_number, phone: @talent.phone, resume: @talent.resume, resume_text: @talent.resume_text } }
    end

    assert_redirected_to talent_url(Talent.last)
  end

  test "should show talent" do
    get talent_url(@talent)
    assert_response :success
  end

  test "should get edit" do
    get edit_talent_url(@talent)
    assert_response :success
  end

  test "should update talent" do
    patch talent_url(@talent), params: { talent: { alt_phone: @talent.alt_phone, email: @talent.email, full_name: @talent.full_name, id_number: @talent.id_number, phone: @talent.phone, resume: @talent.resume, resume_text: @talent.resume_text } }
    assert_redirected_to talent_url(@talent)
  end

  test "should destroy talent" do
    assert_difference("Talent.count", -1) do
      delete talent_url(@talent)
    end

    assert_redirected_to talents_url
  end
end
