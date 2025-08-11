# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
#
# Seed initial tenant and theme

psychos = Tenant.find_or_create_by!(name: "psychOS") do |t|
  t.slug = "psychos"
  t.email = "admin@psychos.local"
  t.locale = "en"
  t.time_zone = "UTC"
  t.homepage_title = "Welcome to psychOS"
  t.homepage_body = "This is the default tenant."
end

# Ensure slug exists if the record existed without it
if psychos.slug.blank?
  psychos.update!(slug: "psychos")
end

# Create a default theme for psychOS if none exists
app_default_theme = psychos.themes.where(name: "App Default").first_or_initialize
if app_default_theme.new_record?
  app_default_theme.html_layout = <<~HTML
    <!doctype html>
    <html>
      <head>
        <meta charset="utf-8">
        <title>{{yield}}</title>
      </head>
      <body class="bg-gray-100">
        <header class="py-16 text-center bg-white shadow-sm mb-5">
          <h1 class="text-4xl font-bold lowercase">psychOS</h1>
        </header>
        <main class="container mx-auto px-5">
          {{yield}}
        </main>
        <footer class="text-center text-xs text-gray-600 py-2">© <%= Time.current.year %> psychOS</footer>
      </body>
    </html>
  HTML
  app_default_theme.css = ""
  app_default_theme.js = ""
  app_default_theme.save!
end

# Assign as default theme if not set
if psychos.default_theme_id.blank?
  psychos.update!(default_theme: app_default_theme)
end

# Seed a default blog
psychos.blogs.find_or_create_by!(title: "Main Blog") do |b|
  b.description = "The default blog for psychOS"
  b.comments_setting = :tenant_only
end

puts "Seeded tenant '#{psychos.name}' with default theme '#{app_default_theme.name}' and a default blog."
