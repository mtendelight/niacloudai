require "test_helper"

class WosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @wo = wos(:one)
  end

  test "should get index" do
    get wos_url
    assert_response :success
  end

  test "should get new" do
    get new_wo_url
    assert_response :success
  end

  test "should create wo" do
    assert_difference("Wo.count") do
      post wos_url, params: { wo: { Details_of_executor: @wo.Details_of_executor, end_time: @wo.end_time, nature: @wo.nature, number: @wo.number, rollback_plan: @wo.rollback_plan, services_to_be_affected: @wo.services_to_be_affected, start_time: @wo.start_time, status: @wo.status, subject: @wo.subject, work_details: @wo.work_details, work_objective: @wo.work_objective } }
    end

    assert_redirected_to wo_url(Wo.last)
  end

  test "should show wo" do
    get wo_url(@wo)
    assert_response :success
  end

  test "should get edit" do
    get edit_wo_url(@wo)
    assert_response :success
  end

  test "should update wo" do
    patch wo_url(@wo), params: { wo: { Details_of_executor: @wo.Details_of_executor, end_time: @wo.end_time, nature: @wo.nature, number: @wo.number, rollback_plan: @wo.rollback_plan, services_to_be_affected: @wo.services_to_be_affected, start_time: @wo.start_time, status: @wo.status, subject: @wo.subject, work_details: @wo.work_details, work_objective: @wo.work_objective } }
    assert_redirected_to wo_url(@wo)
  end

  test "should destroy wo" do
    assert_difference("Wo.count", -1) do
      delete wo_url(@wo)
    end

    assert_redirected_to wos_url
  end
end
