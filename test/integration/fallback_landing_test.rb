require "test_helper"

class FallbackLandingTest < ActionDispatch::IntegrationTest
  test "unknown subdomain falls back to landing without redirect loop" do
    # Unknown tenant slug
    host! "alco.lvh.me"

    get "/"
    assert_response :success
    assert_select "h1", text: "Welcome"
  end

  test "unknown custom domain falls back to landing without redirect loop" do
    host! "unknown-example.com"

    get "/"
    assert_response :success
    assert_select "h1", text: "Welcome"
  end
end
