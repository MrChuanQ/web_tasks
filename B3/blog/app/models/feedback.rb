require "emailvalidator.rb"

class Feedback < ApplicationRecord
  validates :name, presence: true
  validates :email, presence: true, email: true
  validates :content, presence: true, length: { minimum: 10 }
end
