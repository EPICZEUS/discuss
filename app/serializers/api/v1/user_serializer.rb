class Api::V1::UserSerializer < ActiveModel::Serializer
  attributes :id, :username, :first_name, :last_name, :img_url, :owned_rooms

  has_many :owned_rooms
  has_many :rooms
  has_many :messages
end
