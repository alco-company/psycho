# app/services/tailwind/prepare_sources.rb
module Tailwind
  class PrepareSources
    def initialize(tenant)
      @tenant = tenant
    end

    def call
      build_dir = Rails.root.join("tmp/tailwind/tenant_#{@tenant.id}")
      FileUtils.mkdir_p(build_dir)

      theme = @tenant.default_theme || @tenant.themes.first
      theme_css     = theme&.css.to_s
      theme_js      = theme&.js.to_s
      theme_content = theme&.html_layout.to_s # HTML ok; Tailwind scans text

      # Collect post content (ActionText) as HTML so classes inside tags are seen
      posts_html = @tenant.posts.find_each.map { |p|
        p.content&.body&.to_html.to_s
      }.join("\n")

      # Write files Tailwind will scan
      File.write(build_dir.join("themes.css"),         theme_css)
      File.write(build_dir.join("themes.js"),          theme_js)
      File.write(build_dir.join("themes.html_layout"), theme_content)
      File.write(build_dir.join("posts.content.html"), posts_html)

      {
        theme_css: theme_css,
        post_css:  "" # you no longer have a posts.css column
      }
    end
  end
end
