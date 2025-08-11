class Blog < ApplicationRecord
  belongs_to :tenant
  has_many :posts, dependent: :destroy

  enum :comments_setting, { none: 0, tenant_only: 1, users: 2, with_email: 3, all: 4 }, default: :none, prefix: true

  validates :title, presence: true
  validates :comments_setting, presence: true
end
