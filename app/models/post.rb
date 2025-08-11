class Post < ApplicationRecord
  belongs_to :blog
  has_rich_text :content
end
