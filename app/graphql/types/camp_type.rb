module Types
  class CampType < Types::BaseObject
    field :id, ID, null: false
    field :name, String, null: false
    field :subtitle, String, null: false
    field :contact_email, String, null: false
    field :contact_name, String, null: false
    field :contact_phone, String, null: false
    field :description, String, null: true
    field :images, [Types::ImageType], null: true
    field :users, [Types::UserType], null: false
    field :creator, Types::UserType, null: false
    field :tags, [Types::TagType], null:false
  end
end
