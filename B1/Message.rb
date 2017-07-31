#Message.rb
class Message
  attr_accessor :id, :message, :author, :created_at

  def initialize(id, author, created_at, message)
	@id = id
	@message = message
	@author = author
	@created_at = created_at
  end

=begin
  #消息的字符串表示形式
  def to_string()
	
  end
=end
end