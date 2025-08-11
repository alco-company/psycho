require "test_helper"

class TenantHomeRoutingTest < ActionDispatch::IntegrationTest
  MODERN_UA = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/115.0 Safari/537.36"

  test "tenant home via subdomain" do
    Tenant.create!(name: "One", slug: "one-subtest", homepage_title: "One Home", homepage_body: "Hello One")

    host! "one-subtest.example.com"
    get root_url, headers: { "User-Agent" => MODERN_UA }
    assert_response :success
    assert_match "One Home", @response.body
    assert_match "Hello One", @response.body
  end

  test "tenant home via custom domain" do
    t = tenants(:two)
    t.update!(homepage_title: "Two Home via Domain", homepage_body: "Hello Two")
    Domain.create!(host: "custom.test", tenant: t)

    host! "custom.test"
    get root_url, headers: { "User-Agent" => MODERN_UA }
    assert_response :success
    assert_match "Two Home via Domain", @response.body
    assert_match "Hello Two", @response.body
  end
end
