#use Rack::Session::Pool, :expire_after => 120

class MainController < ApplicationController

  protect_from_forgery :except => :index  
  
  # you can disable csrf protection on controller-by-controller basis:  
  skip_before_filter :verify_authenticity_token

  #同时只有通过身份验证的用户才能注册为管理员
  http_basic_authenticate_with name: "admin", password: "secret", except: [:start, :logout]
  #初始界面
  def start
=begin
    if session[:id] != nil  #如果无id返回nil
      redirect_to('/articles')
    else  
      redirect_to('/main/login')
    end
=end
    redirect_to admin_articles_path(0)
  end
  
  #登录
  def login
  end
  
  def login2
    admin_id = params[:id].to_i
    passwordmd5 = Digest::MD5.hexdigest(params[:password])
    
    local_admin = Admin.find_by(id: admin_id, password: passwordmd5)
    
    if local_admin != nil
      session[:id] = local_admin.id
      session[:adminname] = local_admin.name
      redirect_to(admin_articles_path(local_admin))
    else
      redirect_to('/main/login')
    end
  end
  
  #注册
  def signup
    redirect_to new_admin_path
  end
=begin  
  def signup2
    adminname = params[:adminname]
    email = params[:email]
    passwordmd5 = Digest::MD5.hexdigest(params[:password])
    
    if Admin.create(name: adminname, email: email, password: passwordmd5, jurisdiction: true).valid?
      session[:id] = Admin.last.id
      session[:adminname] = adminname
      redirect_to('/main/registration_feedback')
    else
      halt(401, "用户名或邮箱重复，请重新注册!<br><A href=\'main/signup\'>重新注册</A>")
    end
  end
=end 
  #注销登录
  def logout
    session.clear  
    redirect_to('/main/login')
  end
  
  #错误页面
  def error
  end
  
end
