class Tenant < ApplicationRecord
  has_many :domains, dependent: :destroy
  has_many :themes, dependent: :destroy
  has_many :blogs, dependent: :destroy
  belongs_to :default_theme, class_name: "Theme", optional: true

  validates :name, presence: true
  validates :slug, presence: true, uniqueness: true, format: { with: /\A[a-z0-9]+(?:-[a-z0-9]+)*\z/, message: "must be lowercase letters, numbers, and single dashes (no leading/trailing or consecutive dashes)" }

  # For display on homepage
  # attributes: homepage_title, homepage_body
end
