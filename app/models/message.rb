class Message < ApplicationRecord
	validates :content, presence: true, length: {maximum: 2000}
	
  belongs_to :user
  belongs_to :room
end
