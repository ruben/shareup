class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def twitter
    authorization = Authorization.find_by_provider_and_uid("twitter", request.env["omniauth.auth"]["uid"])
    if authorization
      user = authorization.user
    else
      user = User.find_for_twitter_omniauth request.env["omniauth.auth"]
    end
    if user
      sign_in_and_redirect user, :event => :authentication
    else
      redirect_to :new_user_registration
    end
  end
end
