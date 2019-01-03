class Api::V1::RoomSerializer < ActiveModel::Serializer
  attributes :id, :name, :owner

  has_many :users
  has_many :messages

  def owner
  	{
  		id: self.object.owner.id,
  		username: self.object.owner.username,
  		first_name: self.object.owner.first_name,
  		last_name: self.object.owner.last_name,
  		img_url: self.object.owner.img_url
  	}
  end

  class Api::V1::MessageSerializer < ActiveModel::Serializer
  	attributes :id, :content, :created_at, :user, :likes

  	def user
	  	{
	  		id: self.object.user.id,
	  		username: self.object.user.username,
	  		first_name: self.object.user.first_name,
	  		last_name: self.object.user.last_name,
	  		img_url: self.object.user.img_url
	  	}
  	end
  end
end
