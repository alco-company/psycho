require "application_system_test_case"

class TenantHomeSystemTest < ApplicationSystemTestCase
  test "tenant homepage shows name or title" do
    Tenant.create!(name: "Acme", slug: "acme", homepage_title: "Acme Home", homepage_body: "Hello")
    host! "acme.lvh.me"
    visit root_url
    assert_text "Acme Home"
    assert_text "Hello"
  end
end
