class Membership < ApplicationRecord
  belongs_to :collective, polymorphic: true
  belongs_to :user

  scope :for_camp, -> { where(collective_type: :Camp) }
  scope :for_organization, -> { where(collective_type: :Organization) }
end
