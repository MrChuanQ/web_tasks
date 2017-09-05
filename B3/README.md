数据库：blog
表：文章表(articles)、留言表(comments)、反馈表(feedbacks)、管理员账户表(admins)
 1.     articles(文章表)
        字段名     类型                      
        title     string                      
        text      text                      
        admin_id  int
        user_id   int                   
        (隐含字段)
        id        int
     created_at   datetime
     updated_at   datetime
     
  文章表包含的字段为文章的标题(title,内容长度不小于5)，正文(text,内容长度不小于10),管理员ID(admin_id)，文章发表者ID(user_id)和一些其他字段。
  
 2.     留言表(comments)
 
        字段名    类型
        name       string
        email      string
        content    string
        checked    boolean
        article_id int
        user_id    int
        admin_id   int
   
  留言表包含的字段为留言者的姓名(name)，邮箱(email),留言内容(content)，是否通过审核(checked),文章ID(article_id),留言者ID(user_id)，管理员ID(admin_id)，和一些其他字段。
  
 3.     反馈表(feedbacks)
        字段名    类型
        name        string
        email       string
        content     string
        checked     boolean
 
  反馈表包含的字段为反馈者的姓名(name)，邮箱(email),反馈内容(content)，是否通过审核(checked),反馈者ID(user_id)，管理员ID(admin_id)，和一些其他字段。
  
 4.      用户表(users)
        字段名      类型
        name      string
        emial     string
        password  string
      jurisdiction boolean(default=>false)
        
  用户表包含的字段为用户ID(id)，用户姓名(name)，邮箱(email),密码(password),和一些其他字段。
  
 5.     管理员账户表(admins)
          字段名    类型
          name      string
          emial     string
          password  string
        jurisdiction boolean(set=>true)
  
  管理员账户表包含的字段为用户表的超集,增加了权限(jurisdiction)字段。
  
  
控制器为以上数据模型对应的控制器和一个网站入口控制器（mian_controller），路由的的详细设计见config/route，其中主要的路由设计为
>resources :admins do
    resources :articles do
      get 'comments/unchecked'  #get 'admins/:admin_id/articles/:article_id/comments/unchecked'
      resources :comments
    end
  end
从路由设计中便可以看到数据的依赖关系。
 
网站应用的入口控制器控制应用的开始界面、登录和注册等的入口。
其中进入登录和注册的界面需要先进行身份验证，通过mian_controller中的
>  http_basic_authenticate_with name: "admin", password: "secret", except: [:start, :logout]
实现，通过认证后才可进行登录和注册等操作。

网站通过session记录登录信息，未登录的访问者会直接进入文章列表界面，显示所有管理员的所有文章。>redirect_to admin_articles_path(0),实参0是个特殊数据，字面意思是id为0的管理员的所有文章，因为不存在id为0的管理员所以用来表示代表所有管理员。这个参数会在articles_controller中用到。

mian_controller控制器中的注销登录会清除用户的登录信息（清除session），并跳转到登录界面。

articles_controller中的index负责列出一类文章的简短信息，点击一篇具体的文章，会进入文章显示界面，显示文章内容的全文。

管理员可新建、编辑文章、删除文章，一般使用者没有操作权限（通过在控制器判断session信息）。管理员的登录信息仅会在登录时写入session，无法以其他方式改写。

安全保护设计：为防止管理员恶意或意外操作其他管理员，管理员在进行新建、编辑文章、删除文章，会判断管理员是否修改了URL中的admin_id等字段的信息（讲params[:admin_id]与session[:id]判断，session[:id]记录当前管理员的id），若不相同则不进行相关的操作。

文章评论分为已通过检查和未检查（通过checked字段记录），已通过的评论会在前台显示，未检查的评论只有管理员可以查看和进行相关的操作，在.../unchecked页面下显示。

网站的反馈的设计与文章评论相似。

此外，应用还进行了相应的扩展，对普通用户开放了feedback（已检查的）的查看。
添加了用户（User）这一类型，因为普通使用者每次评论都要手动填写相同的用户信息，这无疑是不合适的（当然这个也可以通过将这些信息写入session来解决），但是session无法解决管理上的负担，因为管理员无法有效地管理恶意使用者。而使用User可以解决一部分问题，减少管理上的负担。（为保证设计符合要求，仅设计了其数据类型）
  
另外实现部分：
1.文章的内容支持富文本编辑（使用rails_kindeditor插件）
2.账户密码会通过加密后再存储到数据库，登录时同样通过MD5加密用户输入的密码（通过JavaScript加密提交的表单）
3.提供分页功能(文章分页、留言分页、后台系统中各个列表的分页)。但是会降低效率，如查找一篇文章的评论
>@comments = @article.comments.where(checked: true)
比
>@comments = Comment.paginate(page: params[:page]).where(article_id:  @article.id, checked: true)
效率高

4.会检查提交的内容中有没有包含HTML内容(用户留言和反馈)，用户只能提交纯文本内容，如果出现HTML转义后显示
><%= raw ... %>

未实现部分:) ：
1.前台系统中，为用户提供按月份和分类查看文章
2.前台系统侧边栏没有设计
3.搜索功能
4.后台登录系统，可以提供错误提示以及登录错误次数过多时的账户锁定功能(10分钟内不能再登录)



