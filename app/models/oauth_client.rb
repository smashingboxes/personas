class OauthClient < ActiveRecord::Base
  has_many :templates, :dependent => :destroy, :inverse_of => :oauth_client
   
  accepts_nested_attributes_for :templates, :allow_destroy => true
  attr_accessible :templates_attributes, :allow_destroy => true

  attr_accessible :name, :oauth_identifier, :oauth_secret, :oauth_redirect_uri, :template_ids, :trusted
end
