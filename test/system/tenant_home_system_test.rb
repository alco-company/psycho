require "application_system_test_case"

class TenantHomeSystemTest < ApplicationSystemTestCase
  test "tenant homepage shows name or title" do
    Tenant.create!(name: "Acme", slug: "acme", homepage_title: "Acme Home", homepage_body: "Hello")
    Capybara.app_host = "http://acme.lvh.me"
    visit "/"
    assert_text "Acme Home"
    assert_text "Hello"
  ensure
    Capybara.app_host = nil
  end
end
