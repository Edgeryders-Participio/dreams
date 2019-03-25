class Organization < ActiveRecord::Base
  has_many :events
  has_many :memberships, as: :collective, dependent: :destroy
  has_many :users, through: :memberships
end
