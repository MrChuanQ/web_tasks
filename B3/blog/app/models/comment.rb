require "emailvalidator.rb"

class Comment < ApplicationRecord
  validates :name, presence: true
  validates :email, presence: true, email: true
  validates :content, presence: true, length: { minimum: 10 }
  belongs_to :article
  belongs_to :admin 
end
