RailsAdmin.config do |config|

  config.current_user_method { current_user } # auto-generated
  config.authorize_with :cancan
  config.main_app_name = ['Personas', 'Admin']

  config.attr_accessible_role do
    :admin if _current_user.admin
  end

  config.actions do
    dashboard                     # mandatory
    index                         # mandatory
    new
    export
    bulk_delete
    show
    edit
    delete
  end

  config.model User do
    list do
      field :admin
      field :email
      field :created_at
    end
    export do
      field :admin
      field :email
      field :created_at
    end
    show do
      field :admin
      field :email
      field :created_at
    end
    edit do
      field :admin
      field :email
      field :password
      field :password_confirmation
    end
    create do
      field :admin
      field :email
      field :password
      field :password_confirmation
    end
    update do
      field :admin
      field :email
      field :password
      field :password_confirmation
    end
  end
end
