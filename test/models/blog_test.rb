require "test_helper"

class BlogTest < ActiveSupport::TestCase
  setup do
    @tenant = tenants(:one)
  end

  test "valid factory" do
    blog = Blog.new(tenant: @tenant, title: "Main Blog")
    assert blog.valid?
  end

  test "requires title" do
    blog = Blog.new(tenant: @tenant, title: nil)
    assert_not blog.valid?
    assert_includes blog.errors[:title], "can't be blank"
  end

  test "default comments_setting is none" do
    blog = Blog.new(tenant: @tenant, title: "Main Blog")
    assert_equal "none", blog.comments_setting
    assert blog.comments_setting_none?
  end

  test "enum values" do
    assert_equal 0, Blog.comments_settings[:none]
    assert_equal 1, Blog.comments_settings[:tenant_only]
    assert_equal 2, Blog.comments_settings[:users]
    assert_equal 3, Blog.comments_settings[:with_email]
    assert_equal 4, Blog.comments_settings[:all]
  end
end
