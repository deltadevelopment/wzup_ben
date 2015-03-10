class User < ActiveRecord::Base
  
  # To be able to use password field on registration
  # Auth_token is only required to pass auth_token to newly
  # registered users
  attr_accessor :password, :auth_token, :is_followee

  has_one :status
  has_one :session
  
  has_many :followings, dependent: :destroy
  has_many :followers, through: :followings, source: :followee, foreign_key: 'followee_id', dependent: :destroy

  has_many :waves

  before_save :encrypt_password

  validates :username, length: { in: 1..20, message: "must be between 1 and 15 characters" }
  validates :username, uniqueness: true
  validates_format_of :username, :with => /[a-z0-9]+/i, :message => "can only contain letters and numbers"

  validates :display_name, length: { in: 4..25, message: "must be between 4 and 25 characters" }, if: :display_name_entered
  validates_format_of :display_name, :with => /[a-z0-9 ]+/i, :message => "can only contain letters and numbers", if: :display_name_entered
  
  # This is for other actions than on: :create 
  # TODO: This might be redundant
  validates :password, length: { in: 6..20, message: "must be between 6 and 20 characters" }, if: :password_entered
  
  # TODO: Get better regex for email validation
  validates_format_of :email, 
    :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
  validates :email, uniqueness: true

  validates :phone_number, numericality: {message: "can only contain digits"}, uniqueness: true,
            if: :phone_number_entered


  # TODO: Should this be rewritten using .find and rescue AR?
  def is_follower?(followee_id)
    following = Following.where(user_id: self.id, followee_id: followee_id)
    return true unless following.empty?
    false 
  end

  def is_followee?(follower_id)
    following = Following.where(user_id: follower_id, followee_id: self.id)
    return true unless following.empty?
    false
  end

  def is_invited?(event_id)
    invitation = Invitation.where(invitee_id: self.id, event_id: event_id)
    return true unless invitation.empty?
    false
  end

  def has_private_profile?
    private_profile
  end

  def is_owner?(requester)
    self === requester
  end
  
  # TODO: is this being used?
  def is_follower_or_owner?(resource)
    is_owner?(resource) or is_follower?(resource.id)  
  end

  def is_invited_or_owner?(resource)
    is_owner?(resource.user) or is_invited?(resource.id)
  end

  protected

  # Returns true if a phone number was entered
  def phone_number_entered
    !phone_number.nil?
  end
  
  # Returns true if an e-mail adress was entered 
  def email_entered
    !email.nil?  
  end

  def password_entered
    !password.nil?
  end

  def display_name_entered
    !display_name.nil?
  end

  def encrypt_password
    if password.present?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
    end
  end 

end
