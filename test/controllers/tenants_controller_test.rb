require "test_helper"

class TenantsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @tenant = tenants(:one)
  end

  test "should get index" do
    get tenants_url
    assert_response :success
  end

  test "should get new" do
    get new_tenant_url
    assert_response :success
  end

  test "should create tenant" do
    assert_difference("Tenant.count") do
      post tenants_url, params: { tenant: { email: "new@example.com", locale: "en", name: "New", plan: "free", plan_changed_at: "", plan_expires_at: "", tax_number: "", time_zone: "UTC", slug: "new", homepage_title: "Home", homepage_body: "Welcome" } }
    end

    assert_redirected_to tenant_url(Tenant.last)
  end

  test "should show tenant" do
    get tenant_url(@tenant)
    assert_response :success
  end

  test "should get edit" do
    get edit_tenant_url(@tenant)
    assert_response :success
  end

  test "should update tenant" do
    patch tenant_url(@tenant), params: { tenant: { email: @tenant.email, locale: @tenant.locale, name: @tenant.name, plan: @tenant.plan, plan_changed_at: @tenant.plan_changed_at, plan_expires_at: @tenant.plan_expires_at, tax_number: @tenant.tax_number, time_zone: @tenant.time_zone, slug: @tenant.slug, homepage_title: "Updated", homepage_body: "Updated body" } }
    assert_redirected_to tenant_url(@tenant)
  end

  test "should destroy tenant" do
    assert_difference("Tenant.count", -1) do
      delete tenant_url(@tenant)
    end

    assert_redirected_to tenants_url
  end
end
