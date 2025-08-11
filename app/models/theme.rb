class Theme < ApplicationRecord
  belongs_to :tenant
  has_many :domains, class_name: "Domain", foreign_key: :theme_id, dependent: :nullify

  validates :name, presence: true

  # Optional fields: html_layout, css, js
end
