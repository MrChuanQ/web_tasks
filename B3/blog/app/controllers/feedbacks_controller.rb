class FeedbacksController < ApplicationController
  def index
    @feedbacks = Feedback.paginate(page: params[:page]).where(checked: true)
  end
  
  def unchecked
    redirect_to('/main/error') unless session[:id]
    
    @feedbacks = Feedback.paginate(page: params[:page]).where(checked: false)
  end
  
  def new
    @feedback = Feedback.new()
  end
  
  def edit
    redirect_to('/main/error') unless session[:id]
    
    @feedback = Feedback.find(params[:id])  
  end

   
  def show
    @feedback = Feedback.find(params[:id])
  end
  
  def create
    #render plain: params[:feedback].inspect
    @feedback = Feedback.new(feedback_params)
    if @feedback.save
      redirect_to @feedback
    else
      render :new
    end
  end
  
  def update
    redirect_to('/main/error') unless session[:id]
    
    @feedback = Feedback.find(params[:id]) 
    if @feedback.update(feedback_params)
      redirect_to @feedback
    else
      render 'edit'
    end
  end
  
  def destroy
    if session[:id]
      @feedback = Feedback.find(params[:id])
      @feedback.destroy
 
      redirect_to feedbacks_path
    else
      redirect_to('/main/error')
    end
  end
  
  private
    def feedback_params
      params.require(:feedback).permit(:name, :email, :content, :checked)
    end
    
end
