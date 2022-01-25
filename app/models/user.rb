class User
  include Mongoid::Document
  include Mongoid::Timestamps

  attr_accessor :password

  field :email, type: String
  field :encrypted_password, type: String
  field :salt, type: String

  validates :email, presence: true,
                    uniqueness: { case_sensitive: false },
                    format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }

  validates :password, presence: true,
                       length: { minimum: 8 },
                       if: :new_record

  before_save :encrypt_password

  def self.authenticate(email = '', login_password = '')
    return if email.nil? || login_password.nil?

    user = User.find_by(email: email)

    user if user.present? && user.match_password(login_password)
  end

  def match_password(login_password = '')
    encrypted_password == BCrypt::Engine.hash_secret(login_password, salt)
  end

  private

  def encrypt_password
    return if password.blank?

    self.salt = BCrypt::Engine.generate_salt
    self.encrypted_password = BCrypt::Engine.hash_secret(password, salt)
  end
end
