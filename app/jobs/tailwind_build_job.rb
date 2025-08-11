# app/jobs/tailwind_build_job.rb
class TailwindBuildJob < ApplicationJob
  queue_as :default

  # Optional: require something like good_job/sidekiq uniqueness to coalesce
  # Here’s a simple 500ms debounce using Redis or DB lock would be better in prod.
  def self.perform_unique_later(tenant_id)
    perform_later(tenant_id)
  end

  def perform(tenant_id)
    tenant = Tenant.find(tenant_id)
    return unless Tailwind::ShouldRebuild.changed?(tenant)

    build_dir = Rails.root.join("tmp/tailwind/tenant_#{tenant.id}")
    out_dir   = Rails.root.join("public/assets/tenants/#{tenant.id}")
    FileUtils.mkdir_p(build_dir)
    FileUtils.mkdir_p(out_dir)

    # 1) Materialize DB content to files
    sources = Tailwind::PrepareSources.new(tenant).call # writes files, returns paths

    # 2) Create input.css (imports + tenant layers)
    input_css = build_dir.join("input.css")
    File.write(input_css, <<~CSS + "\n" + sources[:theme_css] + "\n" + sources[:post_css])
      @import "tailwindcss/base";
      @import "tailwindcss/components";
      @import "tailwindcss/utilities";
    CSS

    # 3) Build command
    # Content: app views + phlex + all generated files
    content_globs = [
      Rails.root.join("app/views/**/*.{html,erb}"),
      Rails.root.join("app/views/**/*.rb"),          # for view helpers producing classes
      Rails.root.join("app/phlex/**/*.rb"),          # you mentioned Phlex
      Rails.root.join("app/helpers/**/*.rb"),
      build_dir.join("**/*")                         # theme.js, *.content, etc.
    ].map(&:to_s).join(",")

    # Output path (fingerprint after build)
    tmp_out = build_dir.join("tailwind.css")

    success = build_tailwind!(input_css, tmp_out, content_globs)
    raise "Tailwind build failed for tenant #{tenant.id}" unless success && File.exist?(tmp_out)

    # 4) Fingerprint, move to public
    digest    = Digest::SHA256.file(tmp_out).hexdigest[0, 12]
    final_out = out_dir.join("tailwind-#{digest}.css")
    FileUtils.mv(tmp_out, final_out)

    # 5) Persist the current asset reference on the tenant for easy linking
    tenant.update!(
      tailwind_digest: digest,
      tailwind_built_at: Time.current
    )

    # Optional: clean older css files for this tenant
    Dir[out_dir.join("tailwind-*.css")].each do |path|
      next if path.end_with?("tailwind-#{digest}.css")
      File.delete(path) rescue nil
    end
  end

  private

  def build_tailwind!(input_css, tmp_out, content_globs)
    cmd = [
      "npx", "tailwindcss",
      "-i", input_css.to_s,
      "-o", tmp_out.to_s,
      "--minify",
      "--content", content_globs
    ]

    system({ "NODE_ENV" => Rails.env }, *cmd)
  end
end
