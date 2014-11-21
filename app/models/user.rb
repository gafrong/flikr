class User < ActiveRecord::Base
  has_secure_password

  validates :name, :uniqueness => true
  validates :password_confirmation, :presence => true

  has_many :histories


end
