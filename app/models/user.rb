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
  has_many :created_camps, class_name: :Camp
  # TODO: see if this works to replace the query in users_controller.rb#me
  has_many :collaborator_memberships, through: :created_camps, source: :memberships
  has_many :collaborators, through: :collaborator_memberships, source: :user

  schema_validations whitelist: [:id, :created_at, :updated_at, :encrypted_password]

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create! do |user|
      user.email = auth.uid #.info.email facebook?
      user.password = Devise.friendly_token[0,20]
    end
  end
end
