class Api::V1::RoomSerializer < ActiveModel::Serializer
  attributes :id, :name, :owner

  has_many :users
  has_many :messages

  class Api::V1::MessageSerializer < ActiveModel::Serializer
  	attributes :id, :content, :created_at, :user
  end
end
