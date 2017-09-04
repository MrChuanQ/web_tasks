class ArticlesController < ApplicationController
   #include ActionView::Helpers::SanitizeHelper
  def index
    if params[:admin_id].to_i == 0
      @articles = Article.paginate(page: params[:page])
    else
      @articles = Article.paginate(page: params[:page]).where(admin_id: params[:admin_id])
    end
  end
  
  def new
    redirect_to('/main/error') unless session[:id]
    
    @article = Article.new
  end
  
  def edit
    redirect_to('/main/error') unless session[:id]
    
    @article = Article.find(params[:id])   
  end
  
  def show
    if params[:id]
      @article = Article.find(params[:id])
    else
      redirect_to(admin_articles_path(params[:admin_id]))
    end
  end
  
  def create
    redirect_to('/main/error') unless session[:id]
    
    @article = Article.new
    if params[:admin_id].to_i == session[:id]
      @admin = Admin.find(session[:id])
      @article = @admin.articles.new(article_params)
      #@article.text = strip_tags(params.require(:article).require(:text))
      if @article.save
        redirect_to(admin_article_path(@article.admin, @article))
      else  
        render :new
      end
    else
      #使用者恶意修改url中的admin_id字段
      render(new_admin_article_path(session[:id]))
    end

  end
  
  def update
    redirect_to('/main/error') unless session[:id]
    
    @article = Article.find(params[:id]) 
    if @article.update(article_params)
      redirect_to(admin_article_path(session[:id],@article))
    else
      render 'edit'
    end
  end
  
  def destroy
    if session[:id]   
      @article = Article.find(params[:id])
      @article.destroy
 
      redirect_to(admin_articles_path(session[:id]))
    else
      redirect_to('/main/error')
    end
    
  end
 
  private
    def article_params
      params.require(:article).permit(:title, :text, :admin_id)
    end
  
end
