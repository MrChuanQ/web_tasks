class Article < ApplicationRecord
  validates :title, presence: true, length: { minimum: 5 }
  validates :text, presence: true, length: { minimum: 10 }
  has_many :comments, dependent: :destroy
  belongs_to :admin
end
