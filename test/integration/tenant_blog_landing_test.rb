require "test_helper"

class TenantBlogLandingTest < ActionDispatch::IntegrationTest
  setup do
    @tenant = tenants(:one)
    @tenant.blogs.destroy_all
    @blog = @tenant.blogs.create!(title: "Main Blog", description: "Hello")
  end

  test "GET /blog on tenant host renders single blog directly" do
    host! "one.example.com"
    get "/blog"
    assert_response :success
    assert_includes @response.body, "Main Blog"
    assert_includes @response.body, "Hello"
  end

  test "GET /blog lists multiple blogs when more than one" do
    @tenant.blogs.create!(title: "Second Blog", description: "More")

    host! "one.example.com"
    get "/blog"
    assert_response :success
    assert_includes @response.body, "Main Blog"
    assert_includes @response.body, "Second Blog"
  end

  test "GET /blog/:id shows that blog under tenant host" do
    host! "one.example.com"
    get "/blog/#{@blog.id}"
    assert_response :success
    assert_includes @response.body, "Main Blog"
  end
end
