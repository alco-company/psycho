class Theme < ApplicationRecord
  belongs_to :tenant
  has_many :domains, class_name: "Domain", foreign_key: :theme_id, dependent: :nullify

  before_validation :ensure_name

  validates :name, presence: true

  # Optional fields: html_layout, css, js

  after_commit :enqueue_tailwind_build, if: :saved_change_to_build_inputs?

  def saved_change_to_build_inputs?
    saved_change_to_attribute?(:css) ||
    saved_change_to_attribute?(:js)  ||
    saved_change_to_attribute?(:html_layout)
  end

  private

    def ensure_name
      self.name = "Default Theme" if name.blank?
    end

    def enqueue_tailwind_build
      TailwindBuildJob.perform_unique_later(tenant_id)
    end
end
