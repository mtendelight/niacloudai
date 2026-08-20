require "test_helper"

class CampaignManifestosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @campaign_manifesto = campaign_manifestos(:one)
  end

  test "should get index" do
    get campaign_manifestos_url
    assert_response :success
  end

  test "should get new" do
    get new_campaign_manifesto_url
    assert_response :success
  end

  test "should create campaign_manifesto" do
    assert_difference("CampaignManifesto.count") do
      post campaign_manifestos_url, params: { campaign_manifesto: { budget: @campaign_manifesto.budget, end_date: @campaign_manifesto.end_date, objective: @campaign_manifesto.objective, start_date: @campaign_manifesto.start_date, status: @campaign_manifesto.status, title: @campaign_manifesto.title } }
    end

    assert_redirected_to campaign_manifesto_url(CampaignManifesto.last)
  end

  test "should show campaign_manifesto" do
    get campaign_manifesto_url(@campaign_manifesto)
    assert_response :success
  end

  test "should get edit" do
    get edit_campaign_manifesto_url(@campaign_manifesto)
    assert_response :success
  end

  test "should update campaign_manifesto" do
    patch campaign_manifesto_url(@campaign_manifesto), params: { campaign_manifesto: { budget: @campaign_manifesto.budget, end_date: @campaign_manifesto.end_date, objective: @campaign_manifesto.objective, start_date: @campaign_manifesto.start_date, status: @campaign_manifesto.status, title: @campaign_manifesto.title } }
    assert_redirected_to campaign_manifesto_url(@campaign_manifesto)
  end

  test "should destroy campaign_manifesto" do
    assert_difference("CampaignManifesto.count", -1) do
      delete campaign_manifesto_url(@campaign_manifesto)
    end

    assert_redirected_to campaign_manifestos_url
  end
end
