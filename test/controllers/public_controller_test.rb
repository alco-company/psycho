require "test_helper"

class PublicControllerTest < ActionDispatch::IntegrationTest
  test "root without tenant shows landing" do
    get root_url
    assert_response :success
    assert_select "h1", /Welcome/
  end
end
