class Event < ActiveRecord::Base
  belongs_to :organization
  has_many :grants
  has_many :camps

  has_many :participants, through: :camps, source: :users

  def self.current
    # TODO: make sure this actually works!
    # The intent here is to return the event in the database which is
    # a) starting soonest
    # b) not over yet
    where('ends_at > ?', Time.current).order(starts_at: :asc).first
  end

  scope :past,   -> { where('ends_at < ?', Time.current) }
  scope :future, -> { where('starts_at > ?', Time.current) }
end
