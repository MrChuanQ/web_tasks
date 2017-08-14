$LOAD_PATH<<'.'
require 'sinatra'
require 'mysql2'
require 'rexml/document'
require 'message_manager.rb'
require 'user_manager.rb'
#require 'digest/md5'
#require 'Message.rb'

include REXML
  
use Rack::Session::Pool, :expire_after => 120

xmlfile = File.new("conf.xml")
xmldoc = Document.new(xmlfile)

#获取MySQL数据库的连接用户名
mysql_username = nil
xmldoc.elements.each("database/username") do |e|
  mysql_username = e.text
end

#获取MySQL数据库的连接密码
mysql_password = nil
xmldoc.elements.each("database/password") do |e|
  mysql_password = e.text
end
#建立连接
conn = Mysql2::Client.new(
  :host => 'localhost',
  :port => '3306',
  :pool => '5',
  :username => mysql_username,
  :password => mysql_password)

#创建数据库
sql_create_database = "CREATE DATABASE IF NOT EXISTS bbs;"
conn.query(sql_create_database)

#使用User数据库
sql_use_database = "USE bbs;"
conn.query(sql_use_database)

#删除原表
#drop_table_sql = "DROP TABLE IF EXISTS users;"
#conn.query(drop_table_sql)

#创建users表
sql_create_table_users = "CREATE TABLE IF NOT EXISTS users(
  id int(11) NOT NULL AUTO_INCREMENT,
  username varchar(255) CHARACTER SET gb2312 DEFAULT NULL,
  password varchar(255) DEFAULT NULL,
  PRIMARY KEY (id)
) ENGINE=InnoDB AUTO_INCREMENT=1004 DEFAULT CHARSET=utf8;"

conn.query(sql_create_table_users)

#创建messages表
sql_create_table_messages = "CREATE TABLE IF NOT EXISTS messages (
    id int(11) NOT NULL AUTO_INCREMENT,
    content varchar(255) CHARACTER SET gb2312 DEFAULT NULL,
    user_id int(11) DEFAULT NULL,
    created_at datetime(4) DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP(4),
    author varchar(255) CHARACTER SET gb2312 DEFAULT NULL,
    PRIMARY KEY (id)
  ) ENGINE=InnoDB DEFAULT CHARSET=utf8;"

conn.query(sql_create_table_messages)


#添加元素
=begin
#用户ID 密码
1000  sinatra
1001  45ds556
1002  sad4676
1003  fafasfa
=end

if conn.query("SELECT * FROM users;").size == 0
  sql_add_value =[
  "INSERT INTO users VALUES ('1000', 'frank', '#{Digest::MD5.hexdigest('sinatra')}');",
  "INSERT INTO users VALUES ('1001', 'jack', '#{Digest::MD5.hexdigest('45ds556')}');",
  "INSERT INTO users VALUES ('1002', 'tom', '#{Digest::MD5.hexdigest('sad4676')}');",
  "INSERT INTO users VALUES ('1003', 'lucy', '#{Digest::MD5.hexdigest('fafasfa')}');"]

  sql_add_value.each do |value|
    conn.query(value)
  end
end

#active_record建立连接
ActiveRecord::Base.establish_connection(
  :adapter => 'mysql2',
  :encoding => 'utf8',
  :reconnt => 'false',
  :username => mysql_username,
  :password => mysql_password,
  :host => 'localhost',
  :port => '3306',
  :pool => '5',
  :database => 'bbs')



get '/' do  
  if session[:id] != nil  #如果无id返回nil
    redirect to('/show_message')  
  else  
    redirect to('/login')  
  end  
end  
  
get '/login' do
  erb :login  
end  

#登录验证
post '/login' do
  id = params[:id].to_i
  passwordmd5 = Digest::MD5.hexdigest(params[:password])
    
  require_user = User.new(id: id, password: passwordmd5)
  #require_user.id = id
  #require_user.password = passwordmd5
  
  #登录成功返回用户名
  if username = UserManager.validate_login(require_user)
    session[:id] = require_user.id
    session[:username] = username
    redirect to('/show_message')
  else
    redirect to('/login')
  end
end

#注册
get '/signup' do
  erb :signup
end

post '/signup' do
  username = params[:username]
  passwordmd5 = Digest::MD5.hexdigest(params[:password])
    
  require_user = User.new(username: username, password: passwordmd5)
  #require_user.username = username
  #require_user.password = passwordmd5
  
  #注册成功返回创建的用户ID号
  if id = UserManager.validate_signup(require_user)
    session[:id] = id
    session[:username] = require_user.username
    erb :registration_feedback
  else
    halt(401, "用户名重复，请重新注册!<br><A href=\'/signup\'>重新注册</A>")
  end
end

#注销登录
get '/logout' do  
  session.clear  
  redirect to('/login')  
end

#显示留言板
get '/show_message' do
  halt(401, 'Not Authorized<br><A href=\'/\'>前往首页</A>') unless session[:id]
  
  @mess = Message.all.order(created_at: :desc)
  erb :show_message
end

#发送留言
post '/send_message' do
  halt(401,'Not Authorized<br><A href=\'/\'>前往首页</A>') unless session[:id]
  
  time = params[:time].to_i
  content = params[:content]

  if content.length < 10
    halt(401,"消息内容不能小于10个字！<br><A href=\'/\'>前往首页</A>")
  end
  
  m = Message.new(author: session[:username], user_id: session[:id], created_at: Time.at(time), content: content)
  MessageManager.add_message(m)

  redirect to('/show_message')
end

#删除留言
post '/delete_message' do
  halt(401,'Not Authorized<br><A href=\'/\'>前往首页</A>') unless session[:id]
  
  id = params[:id].to_i

  count = 0
  count = MessageManager.delete_message(id)
  if count == 0
    halt(401,"未找到对应的留言！<br><A href=\'/\'>前往首页</A>")
  else
    halt(302,"已删除对应的#{count}条留言！<br><A href=\'/\'>前往首页</A>")
  end

  redirect to('/show_message')
end

#查询留言
get '/inquire_message' do 
  halt(401,'Not Authorized<br><A href=\'/\'>前往首页</A>') unless session[:id]
    
  filter = params[:filter].strip

  #如果在 filter 的开头没有有效数字，则返回 0。该方法不会生成异常
  filter = filter.to_i==0? filter : filter.to_i

  #此时filter为 nil 或 “” 或 数字
  if filter == ""
    filter = nil
  end

  @inquiry_mess = MessageManager.inquire(filter)

  if @inquiry_mess == nil
    halt(401,"未找到对应的留言！<br><A href=\'/\'>前往首页</A>")
  else
    erb :show_inquiry_message
  end
  
end

#用户管理
get '/user_page' do 
  halt(401,'Not Authorized<br><A href=\'/\'>前往首页</A>') unless session[:id]
  
  erb :user_page
end

#修改密码
post '/modify_password' do
  halt(401,'Not Authorized<br><A href=\'/\'>前往首页</A>') unless session[:id]
  
  old_password = Digest::MD5.hexdigest(params[:old_password])
  old_user = User.new(id: session[:id], password: old_password)

  new_password = Digest::MD5.hexdigest(params[:new_password])
  new_user = User.new(id: session[:id], password: new_password)

  if UserManager.modify_password(old_user, new_user)
    halt(200,'密码修改成功！<br><A href=\'/\'>前往首页</A>')
  else
    halt(401,'原密码输入错误，请重新修改！<br><A href=\'/user_page\'>返回</A>')
  end
end
