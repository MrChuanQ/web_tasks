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
  def Message.get_message()
	if @@message == nil
	  Message.new
	end
	return @@message
  end

  def Message.save_message(message)
	if @@message == nil
		Message.get_message()
	end
	@@message.push(message)
  end

  #消息的字符串表示形式
  def to_string()
	
  end
=end
end