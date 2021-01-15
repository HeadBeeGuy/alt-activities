class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable
         
  validates :username, presence: :true, uniqueness: { case_sensitive: false }, 
									length: { maximum: 28, minimum: 4 }
  # Only allow A through z and spaces in usernames
	validates_format_of :username, with: /\A^[^\s][a-zA-Z0-9_\ ]{4,28}\z/, :multiline => true
  
  validates :email, uniqueness: true, presence: true
  validates :home_country, length: { maximum: 30 }
	validates :location, length: { maximum: 30 }
	validates :bio, length: { maximum: 200 }
  
  has_many :activities, dependent: :destroy
	has_many :upvotes
  has_many :comments, dependent: :destroy
  
  enum role: [:silenced, :normal, :moderator, :admin, :job_poster]
  
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

  def trust
    self.trusted = true
    self.save
  end

  def untrust
    self.trusted = false
    save
  end

  # swiped wholesale from https://old.reddit.com/r/ruby/comments/9qpbok/custom_urls_in_ruby_on_rails_how_you_can_use/e8azvb9/
  def to_param
    "#{id}-#{self.username.parameterize.truncate(80, '')}"
  end
end
