require "test_helper"

class MPayrollsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @m_payroll = m_payrolls(:one)
  end

  test "should get index" do
    get m_payrolls_url
    assert_response :success
  end

  test "should get new" do
    get new_m_payroll_url
    assert_response :success
  end

  test "should create m_payroll" do
    assert_difference("MPayroll.count") do
      post m_payrolls_url, params: { m_payroll: { allowances: @m_payroll.allowances, basic_salary: @m_payroll.basic_salary, deductions: @m_payroll.deductions, m_employee_id: @m_payroll.m_employee_id, net_salary: @m_payroll.net_salary, status: @m_payroll.status } }
    end

    assert_redirected_to m_payroll_url(MPayroll.last)
  end

  test "should show m_payroll" do
    get m_payroll_url(@m_payroll)
    assert_response :success
  end

  test "should get edit" do
    get edit_m_payroll_url(@m_payroll)
    assert_response :success
  end

  test "should update m_payroll" do
    patch m_payroll_url(@m_payroll), params: { m_payroll: { allowances: @m_payroll.allowances, basic_salary: @m_payroll.basic_salary, deductions: @m_payroll.deductions, m_employee_id: @m_payroll.m_employee_id, net_salary: @m_payroll.net_salary, status: @m_payroll.status } }
    assert_redirected_to m_payroll_url(@m_payroll)
  end

  test "should destroy m_payroll" do
    assert_difference("MPayroll.count", -1) do
      delete m_payroll_url(@m_payroll)
    end

    assert_redirected_to m_payrolls_url
  end
end
