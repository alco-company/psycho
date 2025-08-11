# test/services/tailwind/should_rebuild_test.rb
require "test_helper"

class TailwindShouldRebuildTest < ActiveSupport::TestCase
  test "digest changes when theme or post content changes" do
    tenant = tenants(:acme)
    blog = Blog.create!(tenant: tenant, title: "Main Blog")
    post = Post.create!(blog: blog, title: "Hello", published_at: Time.current)
    post.update!(content: "<span class='text-sm'>x</span>")

    assert Tailwind::ShouldRebuild.changed?(tenant)
    first = tenant.reload.tailwind_input_digest
    refute_nil first

    refute Tailwind::ShouldRebuild.changed?(tenant)

    # mutate theme.html_layout
    theme = tenant.default_theme || tenant.themes.first
    theme.update!(html_layout: theme.html_layout.to_s + "<div class='text-xl'></div>")
    assert Tailwind::ShouldRebuild.changed?(tenant.reload)
    second = tenant.reload.tailwind_input_digest
    refute_equal first, second

    # mutate post content
    post.update!(content: post.content.body.to_html + "<p class='text-2xl'>y</p>")
    assert Tailwind::ShouldRebuild.changed?(tenant)
  end
end
