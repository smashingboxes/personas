class Template < ActiveRecord::Base
  attr_accessible :name, :template_type, :content

  belongs_to :oauth_client, :inverse_of => :templates
end
