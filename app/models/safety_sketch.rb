class SafetySketch < ApplicationRecord
  has_attached_file :attachment, {
    styles: {
      thumb: '100x100>',
      square: '324x222#',
      small: '335x257>',
      medium: '700x700>',
      large: '2000x2000>'
    },
    convert_options: {
      all: "-quality 95 -interlace Plane"
    }
  }

  validates_attachment_content_type :attachment, :content_type => /\Aimage\/.*\Z/
end
