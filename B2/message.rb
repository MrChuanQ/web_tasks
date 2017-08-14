#Message.rb

require 'active_record'

class Message < ActiveRecord::Base #ApplicationRecord
  belongs_to :user
end
