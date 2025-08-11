require "test_helper"

class BlogsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @tenant = tenants(:one)
    @blog = Blog.create!(tenant: @tenant, title: "My Blog")
  end

  test "should get index" do
    get blogs_url
    assert_response :success
  end

  test "should get new" do
    get new_blog_url
    assert_response :success
  end

  test "should create blog" do
    assert_difference("Blog.count") do
      post blogs_url, params: { blog: { tenant_id: @tenant.id, title: "New Blog", description: "Desc", comments_setting: "users" } }
    end

    assert_redirected_to blog_url(Blog.order(:created_at).last)
  end

  test "should show blog" do
    get blog_url(@blog)
    assert_response :success
  end

  test "should get edit" do
    get edit_blog_url(@blog)
    assert_response :success
  end

  test "should update blog" do
    patch blog_url(@blog), params: { blog: { title: "Updated" } }
    assert_redirected_to blog_url(@blog)
    @blog.reload
    assert_equal "Updated", @blog.title
  end

  test "should destroy blog" do
    assert_difference("Blog.count", -1) do
      delete blog_url(@blog)
    end

    assert_redirected_to blogs_url
  end
end
