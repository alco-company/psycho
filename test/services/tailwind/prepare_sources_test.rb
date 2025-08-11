# test/services/tailwind/prepare_sources_test.rb
require "test_helper"

class TailwindPrepareSourcesTest < ActiveSupport::TestCase
  test "writes theme files and posts content html" do
    tenant = tenants(:acme)
    blog = Blog.create!(tenant: tenant, title: "Main Blog")
    p1 = Post.create!(blog: blog, title: "Hello")
    p1.update!(content: "<div class='text-green-500'>hi</div>")

    builddir = Rails.root.join("tmp/tailwind/tenant_#{tenant.id}")
    FileUtils.rm_rf(builddir)

    out = Tailwind::PrepareSources.new(tenant).call

    assert_match ".brand", out[:theme_css]
    assert File.exist?(builddir.join("themes.css"))
    assert File.exist?(builddir.join("themes.js"))
    assert File.exist?(builddir.join("themes.html_layout"))
    assert File.exist?(builddir.join("posts.content.html"))

    assert_includes File.read(builddir.join("themes.html_layout")), "bg-blue-600"
    assert_includes File.read(builddir.join("posts.content.html")), "text-green-500"
  end
end
