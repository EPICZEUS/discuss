class Room < ApplicationRecord
	validates :name, presence: true, uniqueness: true

	belongs_to :owner, class_name: "User", foreign_key: "user_id"
	has_and_belongs_to_many :users
	has_many :messages, dependent: :destroy
end
