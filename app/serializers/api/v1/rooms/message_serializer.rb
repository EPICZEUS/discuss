class Api::V1::Rooms::MessageSerializer < ActiveModel::Serializer
  attributes :id, :content, :created_at

  belongs_to :room
end
