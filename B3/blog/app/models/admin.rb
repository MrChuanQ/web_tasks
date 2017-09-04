require "emailvalidator.rb"

class Admin < ApplicationRecord
  validates :name, :password, presence: true
  validates :email, presence: true, email: true, uniqueness: true
  has_many :articles
  has_many :comments
end
