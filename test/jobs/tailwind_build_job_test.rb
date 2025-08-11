# test/jobs/tailwind_build_job_test.rb
require "test_helper"

class TailwindBuildJobTest < ActiveJob::TestCase
  fixtures :tenants, :themes

  setup do
    @tenant = tenants(:acme)
    @blog   = Blog.create!(tenant: @tenant, title: "Main Blog")
    @post   = Post.create!(blog: @blog, title: "Hello", published_at: Time.current)
    @post.update!(content: "<p class='text-red-500'>Hi</p>")
    @build_dir = Rails.root.join("tmp/tailwind/tenant_#{@tenant.id}")
    @out_dir   = Rails.root.join("public/assets/tenants/#{@tenant.id}")
    FileUtils.rm_rf(@build_dir)
    FileUtils.rm_rf(@out_dir)
  end

  test "fingerprints and publishes css" do
    # Force rebuild and bypass expensive check
    original_changed = Tailwind::ShouldRebuild.method(:changed?)
    Tailwind::ShouldRebuild.define_singleton_method(:changed?) { |_tenant| true }

    # Stub PrepareSources to avoid hitting theme/posts
    original_prepare = Tailwind::PrepareSources.instance_method(:call)
    Tailwind::PrepareSources.define_method(:call) do
      { theme_css: "/*theme*/", post_css: "" }
    end

    # Monkeypatch build_tailwind! at class level so perform_now uses it
    original_build = TailwindBuildJob.instance_method(:build_tailwind!)
    TailwindBuildJob.define_method(:build_tailwind!) do |input_css, tmp_out, _|
      FileUtils.mkdir_p(File.dirname(tmp_out))
      File.write(tmp_out, "/* compiled */\n.body{margin:0}")
      true
    end

    TailwindBuildJob.perform_now(@tenant.id)

    @tenant.reload
    assert @tenant.tailwind_digest.present?
    path = @out_dir.join("tailwind-#{@tenant.tailwind_digest}.css")
    assert File.exist?(path)
    assert_includes File.read(path), ".body{margin:0}"
  ensure
    # Restore originals
    Tailwind::ShouldRebuild.define_singleton_method(:changed?, original_changed)
    Tailwind::PrepareSources.define_method(:call, original_prepare)
    TailwindBuildJob.define_method(:build_tailwind!, original_build)
  end
end
