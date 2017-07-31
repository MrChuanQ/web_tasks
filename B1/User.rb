#User.rb
class User
  attr_accessor :username, :password

  def initialize(username, password)
	@username = username
	@password = password
  end

  def eql?(other)
	if !other.is_a?(User)
	  return false
	else
	  return @username == other.username && @password == other.password
	end
  end

end