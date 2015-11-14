# Use Service Object when :
# - The action is complex (e.g. closing the books at the end of an accounting period)
# - The action reaches across multiple models (e.g. an e-commerce purchase using Order, CreditCard and Customer objects)
# - The action interacts with an external service (e.g. posting to social networks)
# - The action is not a core concern of the underlying model (e.g. sweeping up outdated data after a certain time period).
# - There are multiple ways of performing the action (e.g. authenticating with an access token or password). This is the Gang of Four Strategy pattern.
#
# As an example, we could pull a User#authenticate method out into a UserAuthenticator:

# source : http://blog.codeclimate.com/blog/2012/10/17/7-ways-to-decompose-fat-activerecord-models/#service-objects)

class UserAuthenticator
  def initialize(user)
    @user = user
  end

  def authenticate(unencrypted_password)
    return false unless @user

    if BCrypt::Password.new(@user.password_digest) == unencrypted_password
      @user
    else
      false
    end
  end
end

# And the SessionsController would look like this:

class SessionsController < ApplicationController
  def create
    user = User.where(email: params[:email]).first

    if UserAuthenticator.new(user).authenticate(params[:password])
      self.current_user = user
      redirect_to dashboard_path
    else
      flash[:alert] = "Login failed."
      render "new"
    end
  end
end
