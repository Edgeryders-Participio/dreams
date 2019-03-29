class Event < ActiveRecord::Base
  SLUG_FORMAT = /([[:lower:]]|[0-9]+-?[[:lower:]])(-[[:lower:]0-9]+|[[:lower:]0-9])*/
  
  belongs_to :organization
  has_many :grants
  has_many :camps

  has_many :participants, through: :camps, source: :users

  def self.most_relevant
    @@most_relevant ||= where('ends_at > ?', Time.current).order(starts_at: :asc).first
  end

  scope :past,   -> { where('ends_at < ?', Time.current) }
  scope :future, -> { where('starts_at > ?', Time.current) }

  validates :slug,
    presence: true,
    uniqueness: true,
    format: {with: Regexp.new('\A' + SLUG_FORMAT.source + '\z')}

  def to_param
    slug
  end

  def self.find(input)
    input.to_i == 0 ? find_by_slug(input) : super
  end
end
