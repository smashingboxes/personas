class User < ActiveRecord::Base
  has_secure_password

  attr_accessible :admin, as: :admin
  attr_accessible :email, :password, :password_confirmation, as: [ :default, :admin ]
  
  validates_uniqueness_of :email
end
