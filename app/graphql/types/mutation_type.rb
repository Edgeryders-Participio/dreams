module Types
  class MutationType < Types::BaseObject
    field :add_tag, mutation: Mutations::AddTag
    field :remove_tag, mutation: Mutations::RemoveTag
  end
end
