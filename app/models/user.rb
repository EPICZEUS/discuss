class User < ApplicationRecord
	validates :username, presence: true, uniqueness: true
	validates :first_name, presence: true
	validates :last_name, presence: true
	before_validation :defaults
	
	has_many :user_rooms
	has_many :rooms, through: :user_rooms
	has_many :messages

	has_secure_password

	def full_name
		"#{self.first_name} #{self.last_name}"
	end

	def defaults
		self.first_name.capitalize!
		self.last_name.capitalize!

		if  self.img_url.nil? || self.img_url.empty?
				self.img_url = "http://s3.amazonaws.com/37assets/svn/765-default-avatar.png"
		end	
	end
end
