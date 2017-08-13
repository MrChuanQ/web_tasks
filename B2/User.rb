#User.rb

require 'active_record'

class User < ActiveRecord::Base
	validates :username, :password, presence: true
	validates :username, uniqueness: true
end
