#MessageManager.rb

require 'message.rb'

class MessageManager
  #获取全部留言
  def self.get_all_message()
    return Message.all
  end

  #添加留言 返回留言ID
  def self.add_message(message)
    message.save
    return message.id
  end

  #删除留言 传入留言的ID(一个或数组),如果成功返回删除成功的消息条数，如果失败返回一个错误信息
  def self.delete_message(id)
    count = 0
    if id.is_a?(Integer)
      local_message = Message.find_by(id: id)
      if local_message != nil
        local_message.destroy
        count += 1
      end
    else
      id.each do |i|
        local_message = Message.find_by(id: i)
        if local_message != nil
          local_message.destroy
          count += 1
        end
      end
    end

    return count
  end

  #查询留言 
  def self.inquire(filter)
    if filter == nil
      return Message.all
    end

    #按照id查询直接返回一个记录
    if filter.is_a?(Integer)
      local_message = Message.find_by(id: filter)
      if local_message != nil
        return local_message
      end
    end

    #按author查询返回一个记录组
    local_user = User.find_by(username: filter)
    if local_user != nil
      return local_user.messages
    end

    return nil
  end

  private_class_method :new
end
