require "test_helper"

class ThemeTest < ActiveSupport::TestCase
  test "requires name and tenant" do
    t = Theme.new
    assert_not t.valid?
    assert_includes t.errors[:name], "can't be blank"
    assert_includes t.errors[:tenant], "must exist"
  end
end
