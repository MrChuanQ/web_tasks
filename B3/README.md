数据库：blog
表：文章表(articles)、留言表(comments)、反馈表(feedbacks)、管理员账户表(admins)
 1.     articles(文章表)
        字段名     类型                      
        title     string                      
        text      text                      
        checked   boolean                   
        admin_id  int
        user_id   int                   
        (隐含字段)
        id        int
     created_at   datetime
     updated_at   datetime
     
  文章表包含的字段为文章的标题(title,内容长度不小于5)，正文(text,内容长度不小于10),是否通过审核(checked),管理员ID(admin_id)，文章发表者ID(user_id)和一些其他字段。
  
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
        article_id  int
        comment_id  int
        user_id     int
        admint_id   int
 
  反馈表包含的字段为留言表字段的超集，增加了留言ID(comment_id)字段。
  
 4.     用户表(users)
        字段名      类型
        name      string
        emial     string
        password  string
        
  用户表包含的字段为用户ID(id)，用户姓名(name)，邮箱(email),密码(password),和一些其他字段。
  
 5.     管理员账户表(admins)
          字段名    类型
          name      string
          emial     string
          password  string
        jurisdiction boolean
  
  管理员账户表包含的字段为用户表的超集,增加了权限(jurisdiction)字段。
  
  
  问题：
  1.比如自动生成的用户模型为 class User < ApplicationRecord
  那么如何生成管理员模型(继承自User)，而且相同的字段不用重复填写.

  
  
  
