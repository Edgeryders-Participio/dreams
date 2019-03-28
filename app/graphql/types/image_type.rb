module Types
  class ImageType < Types::BaseObject
    field :thumb, String, null: true
    field :square, String, null: true
    field :small, String, null: true
    field :medium, String, null: true
    field :large, String, null: true

    def thumb
      object.attachment.url('thumb')
    end

    def square
      object.attachment.url('square')
    end

    def small
      object.attachment.url('small')
    end

    def medium
      object.attachment.url('medium')
    end

    def large
      object.attachment.url('large')
    end

  end
end
