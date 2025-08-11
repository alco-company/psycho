require "application_system_test_case"

class BlogsTest < ApplicationSystemTestCase
  setup do
    @tenant = tenants(:one)
    @blog = Blog.create!(tenant: @tenant, title: "System Blog")
  end

  test "visiting the index" do
    visit blogs_url
    assert_selector "h1", text: "Blogs"
  end

  test "should create blog" do
    visit blogs_url
    click_on "New blog"

    select @tenant.name, from: "Tenant"
    fill_in "Title", with: "Main Blog"
    fill_in "Description", with: "Some description"
    select "Users", from: "Comments"

    click_on "Create Blog"

    assert_text "Blog was successfully created"
    click_on "Back to blogs"
  end

  test "should update Blog" do
    visit blog_url(@blog)
    click_on "Edit this blog", match: :first

    fill_in "Title", with: "Updated Blog"
    click_on "Update Blog"

    assert_text "Blog was successfully updated"
    click_on "Back to blogs"
  end

  test "should destroy Blog" do
    visit blog_url(@blog)
    accept_confirm { click_on "Destroy this blog", match: :first }

    assert_text "Blog was successfully destroyed"
  end
end
