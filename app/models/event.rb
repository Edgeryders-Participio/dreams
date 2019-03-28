class Event < ActiveRecord::Base
  SLUG_FORMAT = /([[:lower:]]|[0-9]+-?[[:lower:]])(-[[:lower:]0-9]+|[[:lower:]0-9])*/
  
  belongs_to :organization
  has_many :grants
  has_many :camps

  has_many :participants, through: :camps, source: :users

  def self.most_relevant
    where('ends_at > ?', Time.current).order(starts_at: :asc).first
  end

  scope :past,   -> { where('ends_at < ?', Time.current) }
  scope :future, -> { where('starts_at > ?', Time.current) }

  validates :slug,
    presence: true,
    uniqueness: true,
    format: {with: Regexp.new('\A' + SLUG_FORMAT.source + '\z')}
end
