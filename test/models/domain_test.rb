require "test_helper"

class DomainTest < ActiveSupport::TestCase
  test "requires host and tenant" do
    d = Domain.new
    assert_not d.valid?
    assert_includes d.errors[:host], "can't be blank"
    assert_includes d.errors[:tenant], "must exist"
  end

  test "host uniqueness" do
    dup = Domain.new(host: domains(:one).host, tenant: tenants(:two))
    assert_not dup.valid?
    assert_includes dup.errors[:host], "has already been taken"
  end
end
