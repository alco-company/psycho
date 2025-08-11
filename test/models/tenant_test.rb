require "test_helper"

class TenantTest < ActiveSupport::TestCase
  test "requires name and slug" do
    t = Tenant.new
    assert_not t.valid?
    assert_includes t.errors[:name], "can't be blank"
    assert_includes t.errors[:slug], "can't be blank"
  end

  test "slug uniqueness" do
    t = Tenant.new(name: "Dup", slug: tenants(:one).slug)
    assert_not t.valid?
    assert_includes t.errors[:slug], "has already been taken"
  end

  test "slug format" do
    ok = %w[acme acme-1 one-two three3]
    ok.each do |s|
      tenant = Tenant.new(name: "X", slug: s)
      tenant.validate
      assert_empty tenant.errors[:slug], "expected '#{s}' to be valid"
    end

    bad = ["-acme", "acme-", "Acme", "acme_", "", "a--b"]
    bad.each do |s|
      tenant = Tenant.new(name: "X", slug: s)
      assert_not tenant.valid?, "expected '#{s}' to be invalid"
    end
  end
end
