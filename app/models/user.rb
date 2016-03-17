class User < ActiveRecord::Base
  has_many :events
  has_many :meetups, through: :events

  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true


  def self.find_or_create_from_omniauth(auth)
    provider = auth.provider
    uid = auth.uid

    find_or_create_by(provider: provider, uid: uid) do |user|
      user.provider = provider
      user.uid = uid
      user.email = auth.info.email
      user.username = auth.info.name
      user.avatar_url = auth.info.image
    end
  end
end
