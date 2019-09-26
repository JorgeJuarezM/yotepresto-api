
class Authentication

  def initialize (user)
    @username = user[:username]
    @pass = user[:password]
    @user = User.find_by(username: @username)
  end

  def authenticate
    if !@user.nil?
      return @user.authenticate(@pass)
    end
    return false
  end

  def token
    JSONWebToken.encode(user_id: @user.id) if @user
  end

end