class Api::V1::Rooms::MessageSerializer < ActiveModel::Serializer
  attributes :id, :content, :created_at, :likes

  belongs_to :room
  belongs_to :user

  class Api::V1::Rooms::UserSerializer < ActiveModel::Serializer
  	attributes :id, :username, :first_name, :last_name, :img_url
  end
end
