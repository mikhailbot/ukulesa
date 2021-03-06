class User < ApplicationRecord
  has_many :stars
  has_many :repos, :through => :stars

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_initialize.tap do |user|
      user.email = auth.info.email
      user.uid = auth.uid
      user.provider = auth.provider
      user.avatar_url = auth.info.image
      user.name = auth.info.name
      user.username = auth.info.nickname
      user.oauth_token = auth.credentials.token
      user.save!
    end
  end
end
