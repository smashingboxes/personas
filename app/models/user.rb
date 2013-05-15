class User < ActiveRecord::Base
  has_secure_password

  attr_accessible :admin, as: :admin
  attr_accessible :email, :password_digest, :password, :password_confirmation, as: [ :default, :admin ]
  
  validates_format_of :email, :with => /\A[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]+\z/
  validates_presence_of :email
  validates_uniqueness_of :email
  validates_length_of :password, :minimum => 8
  validates_presence_of :password
  validates_presence_of :password_confirmation
  validates_confirmation_of :password

  before_save :email_downcase

  def email_downcase
    self.email = self.email.downcase
  end
end
