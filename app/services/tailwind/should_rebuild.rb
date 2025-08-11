# app/services/tailwind/should_rebuild.rb
module Tailwind
  class ShouldRebuild
    def self.changed?(tenant)
      theme = tenant.default_theme || tenant.themes.first
      theme_fingerprint = [
        theme&.css&.hash,
        theme&.js&.hash,
        theme&.html_layout&.hash
      ].join(":")

      posts_scope = tenant.posts
      posts_stats = posts_scope.pluck(Arel.sql("COUNT(posts.id), COALESCE(MAX(posts.updated_at), '1970-01-01')"))
      count, last_update = posts_stats.first

      cheap_key = "#{theme_fingerprint}|posts:#{count}|last:#{last_update.to_i}"
      return false if tenant.tailwind_input_digest == cheap_key

      # Expensive path only if cheap_key changed:
      # Eager-load ActionText to avoid N+1 when rendering HTML
      posts = posts_scope.includes(:rich_text_content)

      posts_html = posts.map { |p| p.content&.body&.to_html.to_s }.join("\n")

      blob = [
        theme&.css.to_s,
        theme&.js.to_s,
        theme&.html_layout.to_s,
        posts_html
      ].join("\n")

      digest = Digest::SHA256.hexdigest(blob)

      return false if tenant.tailwind_input_digest == digest

      tenant.update_column(:tailwind_input_digest, digest)
      true
    end
  end
end
