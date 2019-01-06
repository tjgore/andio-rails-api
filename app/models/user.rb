class User < ApplicationRecord
	has_secure_password
	before_save :lowercase_email

	has_many :requests, dependent: :destroy

	validates :email, presence: true , uniqueness: { case_sensitive: false }
	validates :email, format: { with: /\S+@\S+\.\S+/ }
	validates :password, :first_name, :last_name, presence: true
  validates :image,  presence: true, blob: { content_type: ['image/png', 'image/jpg', 'image/jpeg', 'application/pdf'], size_range: 1..3.megabytes }
  has_one_attached :image

	def lowercase_email
		self.email = self.email.delete(' ').downcase
	end
end
