class User < ActiveRecord::Base
  
  # To be able to use password field on registration
  attr_accessor :password

  has_one :status
  has_one :session
  
  has_many :followings
  has_many :followers, through: :followings, source: :followee, foreign_key: 'followee_id'

  before_save :encrypt_password

  validates :username, length: { in: 4..15, message: "must be between 4 and 15 characters" }
  validates :username, uniqueness: true

  validates :display_name, length: { in: 4..25, message: "must be between 4 and 25 characters" }
  
  # TODO: Add more demands to password complexity ?
  #       but consider who the users are when upping complexity
  # TODO: Add password confirmation
  validates :password, length: { in: 6..20, message: "must be between 6 and 20 characters" }
  
  # validates :email, presence: true, uniqueness: true

  # TODO: Get better regex for email validation
  validates_format_of :email, 
    :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
  validates :email, uniqueness: true

  validates :phone_number, numericality: {message: "can only contain digits"},
            if: :phone_number_entered

  # Should maybe be refactored with is_followee? they both to the same, the
  # question is which name describes it better.
  def is_follower(user_id)
    following = Following.find_by_user_id_and_followee_id(user_id, self.id)
  end

  def is_followee?(followee_id)
    Following.find_by_user_id_and_followee_id(followee_id, self.id)
  end

  def has_private_profile?
    private_profile
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

  def encrypt_password
    if password.present?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
    end
  end 

end
