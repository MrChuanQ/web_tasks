#User.rb

require 'active_record'

class User < ActiveRecord::Base #ApplicationRecord
  validates :username, :password, presence: true
  validates :username, uniqueness: true
  has_many :messages
end
