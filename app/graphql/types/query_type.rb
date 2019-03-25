module Types
  class QueryType < Types::BaseObject
    field :camps, [CampType], null: false
    field :camp, CampType, null: false do
      argument :id, ID, required: true
    end
    field :user, [UserType], null: false

    def camps
      Camp.all
    end

    def camp(id:)
      Camp.find(id.to_i)
    end

    def users
      User.all
    end
  end
end
