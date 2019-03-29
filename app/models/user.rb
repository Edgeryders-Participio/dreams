class User < ApplicationRecord
  extend AppSettings
  include RegistrationValidation
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => [ :facebook, :saml ]

  has_many :tickets
  has_many :memberships
  has_many :camps, through: :memberships, source: :collective, source_type: :Camp
  has_many :organizations, through: :memberships, source: :collective, source_type: :Organization
  has_many :favorites
  has_many :favorite_camps, through: :favorites, source: :camp
  has_many :created_camps, class_name: :Camp

  has_many :grant_wallets
  
  # TODO: see if this works to replace the query in users_controller.rb#me
  has_many :collaborator_memberships, through: :created_camps, source: :memberships
  has_many :collaborators, through: :collaborator_memberships, source: :user

  schema_validations whitelist: [:id, :created_at, :updated_at, :encrypted_password]

  def self.from_omniauth(auth)
    u = where(provider: auth.provider, uid: auth.uid).first_or_create! do |u|
      u.email = auth.uid # .info.email TODO for supporting other things than keycloak
      u.password = Devise.friendly_token[0,20]
      
      # Omniauth doesn't know the keycloak schema
      u.name = auth.extra.raw_info.all.fetch("urn:oid:2.5.4.42", []).fetch(0, "")
      # Last name : urn:oid:2.5.4.4
      # Roles: raw_info.all["Role"] : array[string]
      # avatars: get https://talk.theborderland.se/api/v1/profile/{username}
      # either loomio picture or gravatar
    end
  end

  def wallet_for(event)
    grant_wallets.find_or_create_by(event: event, user: self) do |w|
      w.grants_left = ENV['DEFAULT_HEARTS'] || 10
    end
  end

  def grants_left_for(event)
    wallet_for(event).grants_left
  end
end
