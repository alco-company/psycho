json.extract! post, :id, :blog_id, :title, :published_at, :created_at, :updated_at
json.url post_url(post, format: :json)
