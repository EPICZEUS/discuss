class User < ApplicationRecord
	has_secure_password
	
	validates :username, presence: true, uniqueness: true

	before_validation :defaults
	
	has_many :owned_rooms, class_name: "Room", inverse_of: "owner"
	has_and_belongs_to_many :rooms
	has_many :messages

	def defaults
		self.first_name ||= ""
		self.last_name ||= ""

		self.first_name.capitalize!
		self.last_name.capitalize!

		if  self.img_url.nil? || self.img_url.empty?
				self.img_url = "http://s3.amazonaws.com/37assets/svn/765-default-avatar.png"
		end	
	end
end
