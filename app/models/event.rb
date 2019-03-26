class Event < ActiveRecord::Base
  belongs_to :organization
  has_many :grants
  has_many :camps

  has_many :participants, through: :camps, source: :users

  def self.most_relevant
    where('ends_at > ?', Time.current).order(starts_at: :asc).first
  end

  scope :past,   -> { where('ends_at < ?', Time.current) }
  scope :future, -> { where('starts_at > ?', Time.current) }
end
