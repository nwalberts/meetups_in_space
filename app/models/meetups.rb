class Meetup < ActiveRecord::Base
  has_many :events
  has_many :users, through: :events

  validates :meetup_name, presence: true
  validates :description, presence: true
  validates :location, presence: true
end
