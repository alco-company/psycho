class Post < ApplicationRecord
  belongs_to :blog
  has_rich_text :content

  # It’s hard to detect ActionText diffs portably; just enqueue on save
  # and let ShouldRebuild short-circuit when inputs are unchanged.
  after_commit :enqueue_tailwind_build

  private
  def enqueue_tailwind_build
    tenant_id = blog&.tenant_id
    return unless tenant_id
    TailwindBuildJob.perform_unique_later(tenant_id)
  end
end
