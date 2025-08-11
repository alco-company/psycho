class Domain < ApplicationRecord
  belongs_to :tenant
  belongs_to :theme, optional: true

  validates :host, presence: true, uniqueness: true
end
