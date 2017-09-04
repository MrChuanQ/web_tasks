class CommentsController < ApplicationController
  def index
    @article = Article.find_by(id: params[:article_id])
    @comments = Comment.paginate(page: params[:page]).where(article_id:  @article.id, checked: true)
    #@comments = @article.comments.where(checked: true)

  end
  
  def unchecked
    redirect_to('/main/error') unless session[:id]
     
    @article = Article.find_by(id: params[:article_id])
    @comments = Comment.paginate(page: params[:page]).where(article_id: @article.id, checked: false)
    #@comments_unchecked = @article.comments.where(checked: false)
     #else redirect_to admin_articles_path (0)
  end
  
  def new
    @article = Article.find_by(id: params[:article_id])
=begin
    article_id = params[:article_id]
    if !article_id && !session[:article_id]
      redirect_to articles_path
    elsif article_id
      session[:article_id] = article_id
    end
=end
    @comment = @article.comments.new()
  end
  
  def edit
    redirect_to('/main/error') unless session[:id]
    
    @article = Article.find_by(id: params[:article_id])
    @comment = @article.comments.find(params[:id])  
  end

   
  def show
    @article = Article.find(params[:article_id])
    if @article
      @comment = @article.comments.find(params[:id])
    else
      redirect_to(admin_article_comments_path(session[:id], @article))
    end
  end
  
  def create
    @article = Article.find(params[:article_id])
    @comment = @article.comments.new(comment_params)
    
    if @comment.save
      redirect_to(admin_article_comment_path(@article.admin, @article, @comment))
    else
      render :new
    end
  end
  
  def update
    redirect_to('/main/error') unless session[:id]
    
    @article = Article.find(params[:article_id])
    @comment = @article.comments.find(params[:id])
    
    if @comment.update(comment_params)
      redirect_to(admin_article_comment_path(@article.admin, @article, @comment))
    else
      render :edit
    end
  end
  
  def destroy
    if session[:id]
      @comment = Comment.find(params[:id])
      @comment.destroy
 
      redirect_to comments_path
    else
      redirect_to('/main/error')
    end
  end
  
  private
    def comment_params
      params.require(:comment).permit(:name, :email, :content, :checked, :article_id, :admin_id)
    end
    

end
