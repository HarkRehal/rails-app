class Post < ApplicationRecord
  validates :title, presence: true, length: { minimum: 5, maximum: 100 }
  validates :content, presence: true, length: { minimum: 10 }
  validates :author, presence: true
  
  scope :published, -> { where.not(published_at: nil) }
  scope :recent, -> { order(published_at: :desc) }
  
  def published?
    published_at.present?
  end
  
  def excerpt(limit = 150)
    content.truncate(limit)
  end
end
