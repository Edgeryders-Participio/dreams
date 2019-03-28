module Mutations
  class AddTag < BaseMutation
    # arguments passed to the `resolved` method
    argument :camp_id, Integer, required: true
    argument :tag, String, required: true

    type [Types::TagType]

    def resolve(camp_id: nil, tag: nil)
      camp = Camp.find(camp_id.to_i)
      camp.tag_list.add(tag, parse:true)
      camp.save
      camp.reload
      camp.tags
    end
  end
end