require "test_helper"

class DynamicThemeRenderingTest < ActionDispatch::IntegrationTest
  setup do
    @tenant = tenants(:one)
    @tenant.update!(default_theme: themes(:default_one))
  end

  test "tenant default theme renders when no domain theme" do
    host! "one.example.com"
    get root_url
    assert_response :success
    assert_includes @response.body, "THEME-ONE"
  end

  test "domain without theme falls back to tenant default theme" do
    d = domains(:one)
    host! d.host
    get root_url
    assert_response :success
    assert_includes @response.body, "THEME-ONE"
  end

  test "domain theme renders when present" do
    t = tenants(:two)
    d = domains(:two)
    d.update!(tenant: t, theme: themes(:two_theme))

    host! d.host
    get root_url
    assert_response :success
    assert_includes @response.body, "THEME-TWO"
  end

  test "domain with theme overrides tenant default" do
    t = tenants(:two)
    d = domains(:two)
    d.update!(tenant: t, theme: themes(:two_theme))

    host! d.host
    get root_url
    assert_response :success
    assert_includes @response.body, "THEME-TWO"
  end
end
