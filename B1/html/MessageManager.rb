#MessageManager.rb
class MessageManager
  def self.get_instance
	return @@manager
  end

  def initialize()
	@mess = Array.new
  end

  #添加留言 返回留言ID
  def add_message(message)
	@mess.push(message)
	return message.id
  end

  #删除留言 传入留言的ID(一个或数组),如果成功返回删除成功的消息条数，如果失败返回一个错误信息
  def delete_message(id)
	count = 0
	if id.is_a?(Fixnum)
	  @mess.each do |m|
        if(id == m.id)
          @mess.delete(m)
          count += 1
        end
      end
	else
	  id.each do |i|
        @mess.each do |m|
          if(i == m.id)
            @mess.delete m
            count += 1
          end
        end
	  end
	end

	return count
  end

  #查询留言 
  def inquire(filter)
    if filter == nil
	  return @mess
    end
	#按照id查询直接返回一个记录
	if filter.is_a?(Fixnum)
	  @mess.each do |m|
		if m.id == filter
			return m
		end
	  end
	end

	#按author查询返回一个记录数组
	author_mess = Array.new	#记录此author的所有留言
	@mess.each do |m|
	  if m.author == filter
		author_mess.push(m)
	  end
	end
	return author_mess
  end

  #为什么这三行代码放在最前面，会使@mess为nil
  @@manager = MessageManager.new
  private_class_method :new
  attr_accessor :mess
end