#UserManager.rb

$LOAD_PATH<<'.'
require 'digest/md5'
require 'active_record'
require 'mysql2'
require "User.rb"



#建立连接
user_conn = Mysql2::Client.new(
	:host => 'localhost',
	:port => '3306',
	:pool => '5',
	:database =>'User',
	:username => "root",
	:password => '1234')

#删除原表
#drop_table_sql = "DROP TABLE IF EXISTS users;"
#user_conn.query(drop_table_sql)

#创建users表
e = nil
begin
	sql_create_database = "CREATE TABLE users (
 		id int(11) DEFAULT NULL,
  	username varchar(255) CHARACTER SET gb2312 DEFAULT NULL,
  	password varchar(255) DEFAULT NULL
	) ENGINE=InnoDB DEFAULT CHARSET=utf8;"
	user_conn.query(sql_create_database)
rescue => e
end

#添加元素
if e == nil
	sql_add_value =[
		"INSERT INTO users VALUES ('1000', 'frank', '0efe415c937f6858550a6378f4f3f374');",
		"INSERT INTO users VALUES ('1001', 'jack', '6760a7c226284bd15ddcf92bfd50428d');",
		"INSERT INTO users VALUES ('1002', 'tom', 'f9f443bc9981d86f44cb2383081a4267');",
		"INSERT INTO users VALUES ('1003', 'lucy', 'bc84d2f9bd7e40784f1401ec4)');"]

	sql_add_value.each do |value|
  	user_conn.query(value)
	end
end

#UserManager.connect_users
#p User.find_by(id: 1000)

class UserManager
	#建立连接
	def self.connect_users()
		ActiveRecord::Base.establish_connection(
			:adapter=>'mysql2',
			:encoding=>'utf8',
			:reconnt=>'false',
			:username=>'root',
			:password=>'1234',
			:host=>'localhost',
			:port=>'3306',
			:pool=>'5',
			:database=>'User')
	end

  #登录验证，成功则返回对应的用户名，否则返回nil
  def self.validate_login(user)
  	self.connect_users
    local_user = User.where(id: user.id, password: user.password)
	#local_user = user_conn.query("select * from users where id = #{user.id} and password = #{user.password}")
		if local_user.size > 0
	  	return local_user[0].username
		else
	  	return nil
		end
  end

  #注册验证，成功则返回生成的id，否则返回nil
  def self.validate_signup(user)
  	self.connect_users
    last = User.last
		if User.create(last.id + 1, username: user.username, password: user.password).valid?
      last = User.last
	  	return last.id
		else
	  	return nil
		end
  end

  #修改密码
  def self.modify_password(old_user, new_user)
  	self.connect_users
		local_user = User.find_by(id: old_user.id)
		if local_user != nil
	  	local_user.password = new_user.password
	  	local_user.save(validate: false) #不在验证用户唯一性
		end
  end

=begin
p User.create(userid: "1506010321", username: "Tom", password: "110")

p User.create(userid: "1506010218", username: "Lucy", password: "120").valid?

p User.create(userid: "1506010318", username: "Jack", password: "189").valid?

p User.find_by(userid: "1506010218").destroy
exit
=end  
    private_class_method :new
end
