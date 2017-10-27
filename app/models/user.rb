# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  email           :string           not null
#  password_digest :string           not null
#  session_token   :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class User < ApplicationRecord
  attr_reader :password

  validates :email, :session_token, presence: true
  validates :password_digest, presence: { message: "Password can't be blank" }
  validates :password, length: { minimum: 6 }
  after_initialize :ensure_session_token

  def self.generate_session_token
    SecureRandom::urlsafe_base64
  end

  def reset_session_token!
    self.session_token = User.generate_session_token
  end

  def ensure_session_token
    self.session_token ||= User.generate_session_token
  end

  def password=(password)
    @password = password # this is just so we can validate password length
    self.password_digest = BCrypt::Password.create(password)
  end

  def is_password?(password) #since we don't have their passwords stored, we still need a way to verify their password
    pass_hash = BCrypt::Password.new(self.password_digest) #converts password digest back to bcrypt object
    pass_hash.is_password?(password)  #runs is_password to see if the password string matches that bcrypt object
  end

  def self.find_by_credentials(email, password) #I believe this will be used for verification later while logging in
    user = User.find_by(email: email)
    return nil unless user
    user.is_password?(password) ? user : nil
  end
end
