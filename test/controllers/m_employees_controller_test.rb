require "test_helper"

class MEmployeesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @m_employee = m_employees(:one)
  end

  test "should get index" do
    get m_employees_url
    assert_response :success
  end

  test "should get new" do
    get new_m_employee_url
    assert_response :success
  end

  test "should create m_employee" do
    assert_difference("MEmployee.count") do
      post m_employees_url, params: { m_employee: { email: @m_employee.email, name: @m_employee.name, phone: @m_employee.phone, position: @m_employee.position, salary: @m_employee.salary, status: @m_employee.status } }
    end

    assert_redirected_to m_employee_url(MEmployee.last)
  end

  test "should show m_employee" do
    get m_employee_url(@m_employee)
    assert_response :success
  end

  test "should get edit" do
    get edit_m_employee_url(@m_employee)
    assert_response :success
  end

  test "should update m_employee" do
    patch m_employee_url(@m_employee), params: { m_employee: { email: @m_employee.email, name: @m_employee.name, phone: @m_employee.phone, position: @m_employee.position, salary: @m_employee.salary, status: @m_employee.status } }
    assert_redirected_to m_employee_url(@m_employee)
  end

  test "should destroy m_employee" do
    assert_difference("MEmployee.count", -1) do
      delete m_employee_url(@m_employee)
    end

    assert_redirected_to m_employees_url
  end
end
