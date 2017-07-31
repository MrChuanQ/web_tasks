#ValidateLogon
require 'digest/md5'
require 'User.rb'
class ValidateLogon
  @@arr_user = nil

  #验证用户登录
  def self.validate_logon(require_user)
    if @@arr_user == nil
	  self.upload_user()
	end

    @@arr_user.each do |user|
      if user.eql?(require_user)
		return true
      end
    end
	return false
  end

  #更新用户信息
  def self.upload_user()
	if @@arr_user == nil
	  @@arr_user = Array.new
	end

	IO.foreach("user_data.txt") do |str_user|
      if str_user[0] != "#"
	    list_inf = str_user.split("\t")
	    user = User.new(list_inf[0], Digest::MD5.hexdigest(list_inf[1].chomp()))
	    @@arr_user.push(user)
      end
    end
  end

  private_class_method :new

end