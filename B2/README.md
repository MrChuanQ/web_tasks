问题:注册和修改密码时报错，目前还不知道是什么原因，不知道怎么改。
几组可用的用户（已在程序中写入数据库）
#ID     密码
1000	sinatra
1001	45ds556
1002	sad4676
1003	fafasfa

注：数据库使用的是MySQL，密码写在代码中了:)。改密码需要修改两个文件（MessageManager.rb和UserManager.rb），每个文件需要改两处。使用时需要先创建User和Message两个数据库(create database User/Message;)，对于表程序自己会创建。

mian.rb:负责流程的控制和用户请求处理方法的调用。用户进入任何一个页面都会先判断其是否已登录（通过session实现）。
        若用户120秒未进行任何操作，则自动退出登录（use Rack::Session::Pool, :expire_after => 120）。
	拥有对登录，登录验证，注销登录，用户管理，发送、删除、查询消息等管理功能

MessageManager.rb:为留言的管理部件，可以对所有的进行管理（查询、删除）。
	特别的，对于查询功能，此函数并未针对不同的需求而定义一些相似或重载函数。其通过函数实参的类型或内容
	来进行不同的操作

UserManager.rb:为登录验证工具，不提供实例对象（私有化了new方法）。负责对用户发送的登录信息通过数据库进行验证。
        内部方法都为类方法，分为验证用户登录和更新用户信息。


Message.rb:为消息类，继承ActiveRecord::Base

User.rb:为用户类，继承ActiveRecord::Base

login.erb:提交用户信息（用户名和密码）

user_page:用户个人页面，可以查看到当前的用户信息以及提交的留言列表

show_message.erb:为用户操作的主界面。分为三个部分：留言消息显示区，留言查询区，留言上传区。
        通过表格显示留言消息，通过表单提交请求，通过文本区输入留言。

show_inquiry_message.erb:用于显示查询到的留言信息
