class OauthClient < ActiveRecord::Base
  attr_accessible :name, :oauth_identifier, :oauth_secret, :oauth_redirect_uri, :trusted
end
