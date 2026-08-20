require "test_helper"

class MAdventuresControllerTest < ActionDispatch::IntegrationTest
  setup do
    @m_adventure = m_adventures(:one)
  end

  test "should get index" do
    get m_adventures_url
    assert_response :success
  end

  test "should get new" do
    get new_m_adventure_url
    assert_response :success
  end

  test "should create m_adventure" do
    assert_difference("MAdventure.count") do
      post m_adventures_url, params: { m_adventure: { address: @m_adventure.address, end_date: @m_adventure.end_date, location: @m_adventure.location, name: @m_adventure.name, photo_url: @m_adventure.photo_url, plan: @m_adventure.plan, rate: @m_adventure.rate, start_date: @m_adventure.start_date } }
    end

    assert_redirected_to m_adventure_url(MAdventure.last)
  end

  test "should show m_adventure" do
    get m_adventure_url(@m_adventure)
    assert_response :success
  end

  test "should get edit" do
    get edit_m_adventure_url(@m_adventure)
    assert_response :success
  end

  test "should update m_adventure" do
    patch m_adventure_url(@m_adventure), params: { m_adventure: { address: @m_adventure.address, end_date: @m_adventure.end_date, location: @m_adventure.location, name: @m_adventure.name, photo_url: @m_adventure.photo_url, plan: @m_adventure.plan, rate: @m_adventure.rate, start_date: @m_adventure.start_date } }
    assert_redirected_to m_adventure_url(@m_adventure)
  end

  test "should destroy m_adventure" do
    assert_difference("MAdventure.count", -1) do
      delete m_adventure_url(@m_adventure)
    end

    assert_redirected_to m_adventures_url
  end
end
