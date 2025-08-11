class Tenant < ApplicationRecord
  has_many :domains, dependent: :destroy
  has_many :themes, dependent: :destroy
  has_many :blogs, dependent: :destroy
  has_many :posts, through: :blogs
  belongs_to :default_theme, class_name: "Theme", optional: true

  before_validation :ensure_slug

  validates :name, presence: true
  validates :slug, presence: true, uniqueness: true, format: { with: /\A[a-z0-9]+(?:-[a-z0-9]+)*\z/, message: "must be lowercase letters, numbers, and single dashes (no leading/trailing or consecutive dashes)" }

  # For display on homepage
  # attributes: homepage_title, homepage_body'

  # app/models/tenant.rb
  def tailwind_asset_url
    return "/assets/tenants/#{id}/tailwind-#{tailwind_digest}.css" if tailwind_digest.present?
    # fallback to a global default (checked in to repo)
    "/assets/default/tailwind.css"
  end

  private
  def ensure_slug
    return if slug.present?
    base = name.to_s.parameterize.presence || "tenant"
    candidate = base
    i = 2
    while Tenant.where.not(id: id).exists?(slug: candidate)
      candidate = "#{base}-#{i}"
      i += 1
    end
    self.slug = candidate
  end
end
