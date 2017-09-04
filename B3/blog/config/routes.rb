Rails.application.routes.draw do
  get 'main/start'
  root 'main#start'
  
  get 'main/login'
  post 'main/login2'
  
  get 'main/signup'
  
  get 'main/logout'
  
  get 'main/error'
  
  get 'feedbacks/unchecked'
  resources :feedbacks

  #get 'comments/unchecked'必须写在resources :comments前面否则controller既找不到comment_unchecked_path也找不到‘/comments/unchecked’，而且讲‘/comments/unchecked’链接到‘/comments/show’上
  

  resources :admins do
    resources :articles do
      get 'comments/unchecked'  #get 'admins/:admin_id/articles/:article_id/comments/unchecked'
      resources :comments
    end
  end
  
=begin  
  resources :users do
    resources :articles do
      resources :comments
    end
  end
=end
  
end
