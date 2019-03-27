class User < ApplicationRecord
  extend AppSettings
  include RegistrationValidation
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => [ :facebook, :saml ]

  has_many :tickets
  has_many :memberships
  has_many :camps, through: :memberships
  has_many :created_camps, class_name: :Camp

  schema_validations whitelist: [:id, :created_at, :updated_at, :encrypted_password]

  def self.from_omniauth(auth)
    u = where(provider: auth.provider, uid: auth.uid).first_or_create! do |user|
      user.email = auth.uid # .info.email TODO for supporting other things than keycloak
      user.password = Devise.friendly_token[0,20]
    end
    # Omniauth doesn't know the keycloak schema
    u.name = auth.extra.raw_info.all["urn:oid:2.5.4.42"][0]
    # Last name : urn:oid:2.5.4.4
    # Roles: raw_info.all["Role"] : array[string]
    # avatars: get https://talk.theborderland.se/api/v1/profile/{username}
    # either loomio picture or gravatar
    u.save!
    u
  end
end
