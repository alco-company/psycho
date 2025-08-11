require "test_helper"

class TenantBlogLatestPostsTest < ActionDispatch::IntegrationTest
  setup do
    @tenant = tenants(:one)
    @tenant.blogs.destroy_all
    @blog = @tenant.blogs.create!(title: "Main Blog")
  end

  def extract_latest(response_body)
    doc = Nokogiri::HTML.fragment(response_body)
    doc.css('[data-test-id="latest-posts"] .text-sm .font-medium').map(&:text)
  end

  test "no posts shows message" do
    host! "one.example.com"
    get "/blog"
    assert_response :success
    assert_includes @response.body, "No posts yet"
  end

  test "four posts show all four" do
    4.times do |i|
      @blog.posts.create!(title: "P#{i}", published_at: Time.current - i.days)
    end

    host! "one.example.com"
    get "/blog"
    assert_response :success
    titles = extract_latest(@response.body)
    assert_equal [ "P0", "P1", "P2", "P3" ], titles
  end

  test "six posts show latest five by published_at desc" do
    6.times do |i|
      @blog.posts.create!(title: "P#{i}", published_at: Time.current - i.days)
    end

    host! "one.example.com"
    get "/blog"
    assert_response :success
    titles = extract_latest(@response.body)
    assert_equal [ "P0", "P1", "P2", "P3", "P4" ], titles
    refute_includes titles, "P5"
  end
end
