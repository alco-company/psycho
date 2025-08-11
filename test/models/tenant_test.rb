require "test_helper"

class TenantTest < ActiveSupport::TestCase
  test "requires name and auto-generates slug" do
    t = Tenant.new
    assert_not t.valid?
    assert_includes t.errors[:name], "can't be blank"
    assert_empty t.errors[:slug]
  end

  test "slug uniqueness" do
    t = Tenant.new(name: "Dup", slug: tenants(:one).slug)
    assert_not t.valid?
    assert_includes t.errors[:slug], "has already been taken"
  end

  test "slug format" do
    ok = %w[acme-unique acme-1 one-two three3]
    ok.each do |s|
      tenant = Tenant.new(name: "X", slug: s)
      tenant.validate
      assert_empty tenant.errors[:slug], "expected '#{s}' to be valid"
    end

    bad = [ "-acme", "acme-", "Acme", "acme_", "a--b" ]
    bad.each do |s|
      tenant = Tenant.new(name: "X", slug: s)
      assert_not tenant.valid?, "expected '#{s}' to be invalid"
    end
  end

  test "tailwind_asset_url falls back when digest missing" do
    t = tenants(:acme)
    t.update!(tailwind_digest: nil)
    assert_equal "/assets/default/tailwind.css", t.tailwind_asset_url
  end

  test "tailwind_asset_url returns tenant-specific path when digest present" do
    t = tenants(:acme)
    t.update!(tailwind_digest: "abc123def456")
    assert_equal "/assets/tenants/#{t.id}/tailwind-abc123def456.css", t.tailwind_asset_url
  end
end
