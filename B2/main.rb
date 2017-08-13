$LOAD_PATH<<'.'
require 'sinatra'  
require 'digest/md5'
require 'Message.rb'
require 'MessageManager.rb'
require 'User.rb'
require 'UserManager.rb'
  
use Rack::Session::Pool, :expire_after => 120  


get '/' do  
  if session[:id] != nil && session[:id] != ""
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
  
  UserManager.connect_users
  
  require_user = User.new
  require_user.id = id
  require_user.username =  ""
  require_user.password = passwordmd5
 
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
  
  UserManager.connect_users
  
  require_user = User.new
  require_user.id = 0
  require_user.username = username
  require_user.password = passwordmd5
  

  if id = UserManager.validate_signup(require_user)
		session[:id] = id
		session[:username] = require_user.username
		erb :registration_feedback
  else
		halt(401, "用户名重复，请重新注册<br><A href=\'/\'>重新注册</A>")
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
  
  MessageManager.connect_messages
  @mess = Message.all.order(created_at: :desc)
  #session[:mess] = mess
  erb :show_message
end

#发送留言
post '/send_message' do
  halt(401,'Not Authorized<br><A href=\'/\'>前往首页</A>') unless session[:id]
  
  MessageManager.connect_messages
  
  next_id = 0
  if Message.last == nil
	next_id = 1
  else
	next_id = Message.last.id + 1
  end
  
  time = params[:time].to_i
  content = params[:content]

  if content.length < 10
	halt(401,"消息内容不小于10个字<br><A href=\'/\'>前往首页</A>")
  end

  m = Message.new(id: next_id, author: session[:username], user_id: session[:id], created_at: Time.at(time), content: content)

  MessageManager.add_message(m)

  redirect to('/show_message')
end

#删除留言
post '/delete_message' do
  halt(401,'Not Authorized<br><A href=\'/\'>前往首页</A>') unless session[:id]
  
  MessageManager.connect_messages

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
  
  MessageManager.connect_messages
  
  filter = params[:filter].strip

  filter = filter.to_i==0? filter : filter.to_i
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
  id = session[:id]
  
  UserManager.connect_users

  old_password = Digest::MD5.hexdigest(params[:old_password])
  old_user = User.new
  old_user.id = id
  old_user.username =  ""
  old_user.password = old_password

  new_password = Digest::MD5.hexdigest(params[:new_password])
  new_user = User.new
  new_user.id = id
  new_user.username =  ""
  new_user.password = new_password

  UserManager.modify_password(old_user, new_user)
end
