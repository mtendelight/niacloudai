require "application_system_test_case"

class CertificatesTest < ApplicationSystemTestCase
  setup do
    @certificate = certificates(:one)
  end

  test "visiting the index" do
    visit certificates_url
    assert_selector "h1", text: "Certificates"
  end

  test "should create certificate" do
    visit certificates_url
    click_on "New certificate"

    fill_in "Certificate no", with: @certificate.certificate_no
    fill_in "College name", with: @certificate.college_name
    fill_in "Course", with: @certificate.course
    fill_in "Full name", with: @certificate.full_name
    fill_in "Issue date", with: @certificate.issue_date
    fill_in "Logo", with: @certificate.logo
    click_on "Create Certificate"

    assert_text "Certificate was successfully created"
    click_on "Back"
  end

  test "should update Certificate" do
    visit certificate_url(@certificate)
    click_on "Edit this certificate", match: :first

    fill_in "Certificate no", with: @certificate.certificate_no
    fill_in "College name", with: @certificate.college_name
    fill_in "Course", with: @certificate.course
    fill_in "Full name", with: @certificate.full_name
    fill_in "Issue date", with: @certificate.issue_date
    fill_in "Logo", with: @certificate.logo
    click_on "Update Certificate"

    assert_text "Certificate was successfully updated"
    click_on "Back"
  end

  test "should destroy Certificate" do
    visit certificate_url(@certificate)
    click_on "Destroy this certificate", match: :first

    assert_text "Certificate was successfully destroyed"
  end
end
