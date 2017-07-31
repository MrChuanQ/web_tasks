$LOAD_PATH<<'.'
require 'sinatra'  
require 'digest/md5'
require 'Message.rb'
require 'MessageManager.rb'
require 'ValidateLogon.rb'
  
use Rack::Session::Pool, :expire_after => 120  
=begin  
configure do  
  enable :sessions  
  set :username, 'frank'  
  set :passwordmd5, '0efe415c937f6858550a6378f4f3f374'  #'sinatra'  
end
=end

#登录验证
def validate_logon(require_user)
  return ValidateLogon.validate_logon(require_user)
end

  
get '/' do  
  if session[:admin] == true  
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
  username = params[:username]
  passwordmd5 = Digest::MD5.hexdigest(params[:password])
  require_user = User.new(username, passwordmd5)
 
  if validate_logon(require_user)
	session[:admin] = true
	session[:username] = require_user.username
    redirect to('/show_message')
  else
	erb :login
  end
=begin
  if params[:username] == settings.username && Digest::MD5.hexdigest(params[:password]) == settings.passwordmd5  
    session[:admin] = true  
    redirect to('/show_message')  
  else  
    erb :login  
  end
=end
end

#注销登录
get '/logout' do  
  session.clear  
  redirect to('/login')  
end

#显示留言板
get '/show_message' do
  halt(401,'Not Authorized') unless session[:admin]
  erb :show_message
end

#发送留言
post '/send_message' do
  halt(401,'Not Authorized') unless session[:admin]

  id = params[:id].to_i
  author = params[:author]
  time = params[:time].to_i
  message = params[:message]
  if message.length < 10
	halt(401,"消息内容不小于10个字<br><A href=\'/\'>前往首页</A>")
  end
  m = Message.new(id,author,Time.at(time),message)

  manager = MessageManager.get_instance()
  manager.add_message(m)

  redirect to('/show_message')
end

#删除留言
post '/delete_message' do
  halt(401,'Not Authorized') unless session[:admin]

  id = params[:id].to_i
  manager = MessageManager.get_instance()

  count = 0
  count = manager.delete_message(id)
  if count == 0
	halt(401,"未找到对应的留言！<br><A href=\'/\'>前往首页</A>")
  else
	halt(302,"已删除对应的#{count}条留言！<br><A href=\'/\'>前往首页</A>")
  end

  redirect to('/show_message')
end

#查询留言
get '/inquire_message' do 
  halt(401,'Not Authorized') unless session[:admin]

  erb :show_inquiry_message
end

#用户管理
get '/user_page' do 
	halt(401,'Not Authorized') unless session[:admin]

	#erb :user_page 下次任务中实现
end