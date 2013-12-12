class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable
  has_many :authorizations, dependent: :destroy

  def self.find_for_twitter_omniauth authorization_response
    unless user = User.find_by_name(name)
      user = User.create_from_authorization_response authorization_response
    end
    user.create_twitter_omniauth_authorization authorization_response
    user
  end

  def self.create_from_authorization_response authorization_response
    User.create(name: authorization_response['info']['name'],
                password: Devise.friendly_token[0, 8],
                email: "#{UUIDTools::UUID.random_create}@shareup.com"
    )
  end

  def create_twitter_omniauth_authorization authorization_response
    unless  authorization = user.authorizations.find_by_provider(authorization_response['provider'])
      authorization = user.authorizations.create(provider: authorization_response['provider'], uid: authorization_response['uid'])
    end
    authorization.update_twitter_token authorization_response
  end
end
