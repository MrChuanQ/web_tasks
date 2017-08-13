#MessageManager.rb

require 'mysql2'
require 'active_record'
require 'Message.rb'



#建立连接
message_conn = Mysql2::Client.new(
  :host => "localhost",
  :port => '3306',
	:pool => '5',
  :database => "Message",
	:username => "root",
	:password => '1234')
  

#删除原表
#drop_table_sql = "DROP TABLE IF EXISTS messages;"
#message_conn.query(drop_table_sql)

#创建messages表
begin
	sql_create_database = "CREATE TABLE messages (
  	id int(11) NOT NULL AUTO_INCREMENT,
  	content varchar(255) CHARACTER SET gb2312 DEFAULT NULL,
  	user_id int(11) DEFAULT NULL,
  	created_at datetime(4) DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP(4),
  	author varchar(255) CHARACTER SET gb2312 DEFAULT NULL,
  	PRIMARY KEY (id)
	) ENGINE=InnoDB DEFAULT CHARSET=utf8;"

message_conn.query(sql_create_database)
rescue Mysql2::Error
end

#message_conn.query("INSERT INTO messages VALUES ('0',  '', '0', '2017-1-1', 'admin');")

class MessageManager
	#建立连接
	def self.connect_messages()
		ActiveRecord::Base.establish_connection(
			:adapter=>'mysql2',
			:encoding=>'utf8',
			:reconnt=>'false',
			:username=>'root',
			:password=>'1234',
			:host=>'localhost',
			:port=>'3306',
			:pool=>'5',
			:database=>'Message')
	end

  #获取全部留言
  def self.get_all_message()
  	self.connect_messages
	  return Message.all
  end

  #添加留言 返回留言ID
  def self.add_message(message)
  	self.connect_messages
	  message.save
	  return message.id
  end

  #删除留言 传入留言的ID(一个或数组),如果成功返回删除成功的消息条数，如果失败返回一个错误信息
  def self.delete_message(id)
  	self.connect_messages
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
  	self.connect_messages
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

	  #按author查询返回一个记录数组
	  local_message = Message.where(author: filter)
	  if local_message != nil && local_message.size != 0
		  return local_message
	  end

	  return nil
  end

  #private_class_method :new
end
