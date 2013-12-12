class Authorization < ActiveRecord::Base
  belongs_to :user

  def update_twitter_token authorization_response
    update_attributes(
        uid: authorization_response['uid'],
        token: authorization_response['credentials']['token'],
        secret: authorization_response['credentials']['secret'],
        name: name,
        url: "http://twitter.com/#{ name}"
    )
  end
end
