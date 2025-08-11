require "test_helper"

class PostTest < ActiveSupport::TestCase
  test "enqueues build after commit when content changes" do
    tenant = tenants(:acme)
    blog = Blog.create!(tenant: tenant, title: "Main Blog")
    post = Post.create!(blog: blog, title: "Hello")

    assert_enqueued_with(job: TailwindBuildJob) do
      post.update!(content: "<p class='text-blue-500'>Hi</p>")
    end
  end
end
