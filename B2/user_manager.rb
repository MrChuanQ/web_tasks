#UserManager.rb

$LOAD_PATH<<'.'
require 'digest/md5'
require "user.rb"


class UserManager
  #登录验证，成功则返回对应的用户名，否则返回nil
  def self.validate_login(user)
    local_user = User.where(id: user.id, password: user.password)
  #local_user = conn.query("select * from users where id = #{user.id} and password = #{user.password}")
    if local_user != nil && local_user.size > 0
      return local_user[0].username
    else
      return nil
    end
  end

  #注册验证，成功则返回生成的id，否则返回nil
  def self.validate_signup(user)
    if User.create(username: user.username, password: user.password).valid?
      return User.last.id
    else
      return nil
    end
  end

  #修改密码
  def self.modify_password(old_user, new_user)
    local_user = User.find_by(id: old_user.id, password: old_user.password)
    if local_user != nil
      local_user.password = new_user.password
      local_user.save() #不在验证用户唯一性
    end
  end

  private_class_method :new
end
