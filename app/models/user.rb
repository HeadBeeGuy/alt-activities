class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
         
  validates :username, presence: :true, uniqueness: { case_sensitive: false }
  # Only allow letter, number, underscore and punctuation.
  validates_format_of :username, with: /^[a-zA-Z0-9_\.]*$/, :multiline => true
  
  validates :email, uniqueness: true, presence: true
  validates :home_country, length: { maximum: 30 }
	validates :location, length: { maximum: 30 }
	validates :bio, length: { maximum: 200 }
  
  has_many :activities
  
  enum role: [:silenced, :normal, :moderator, :admin]
  
  # making a "login" virtual attribute, as per Devise wiki: 
  # https://github.com/plataformatec/devise/wiki/How-To:-Allow-users-to-sign-in-using-their-username-or-email-address
  attr_accessor :login
  
  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions.to_h).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    elsif conditions.has_key?(:username) || conditions.has_key?(:email)
      where(conditions.to_h).first
    end
  end

	# I confess I'm not sure if it's better to do this in the controller or the model
	def set_role(role)
		self.role = role
		self.save
	end
end
