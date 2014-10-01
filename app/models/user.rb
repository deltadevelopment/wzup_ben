class User < ActiveRecord::Base
  
  # To be able to use password field on registration
  attr_accessor :password

  has_one :status
  has_one :session
  
  has_many :followings
  has_many :followers, through: :followings, source: :followee, foreign_key: 'followee_id'

  before_save :encrypt_password

  validates :username, length: { in: 1..15, message: "must be between 1 and 15 characters" }
  validates :username, uniqueness: true

  validates :display_name, length: { in: 4..25, message: "must be between 4 and 25 characters" }, if: :display_name_entered
  
  validates :password, length: { in: 6..20, message: "must be between 6 and 20 characters" }, on: :create
  
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

  def has_private_profile?
    private_profile
  end

  def is_owner?(requester)
    self === requester
  end

  def is_follower_or_owner?(resource)
    is_owner?(resource) or is_follower?(resource.id)  
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
