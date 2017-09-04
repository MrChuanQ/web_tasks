class AdminsController < ApplicationController
  http_basic_authenticate_with name: "admin", password: "secret", only: :new
  
  def index
    redirect_to('/main/error') unless session[:id]
    
    @admins = Admin.paginate(page: params[:page])
  end
  
  def new
    @admin = Admin.new
  end
  
  def edit
    redirect_to('/main/error') unless session[:id]
    
    @admin = Admin.find(params[:id])   
  end
  
  def show
    #防止管理员恶意操作其他管理员的账号
    if session[:id] != nil && session[:id] == params[:id].to_i
      @admin = Admin.find(params[:id])
    else
      redirect_to '/main/login'
    end
  end
  
  def create
    @admin = Admin.new(admin_params)
    if @admin.save
      session[:id] = @admin.id
      session[:adminname] = @admin.name
      redirect_to @admin
    else
      render 'new'
    end
  end
  
  def update
    redirect_to('/main/error') unless session[:id]
    
    @admin = Admin.find(params[:id])
    if params[:old_password] != @admin.password
      @admin.errors.add(:passwod,"that you input is not the same as the old password!")
      render 'edit'
    elsif @admin.update(admin_params)
      redirect_to @admin
    else
      render 'edit'
    end
  end
  
  def destroy
    if session[:id]
      @admin = Admin.find(params[:id])
      @admin.destroy

      redirect_to '/main/logout'
    else
      redirect_to('/main/error')
    end
    
  end
 
  private
    def admin_params
      params.require(:admin).permit(:name, :email, :password, :jurisdiction)
    end
  
end
