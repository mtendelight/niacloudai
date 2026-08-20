RailsAdmin.config do |config|
  config.asset_source = :importmap
   class RailsAdmin::Config::Fields::Types::Inet < RailsAdmin::Config::Fields::Base
    RailsAdmin::Config::Fields::Types::register(self)
  end
  ### Popular gems integration

  ## == Devise ==
  #config.authenticate_with do
   #warden.authenticate! scope: :user
   #end
  #config.current_user_method(&:current_user)



  ## == Cancan ==
  config.authorize_with :cancan


  #config.authenticate_with do
    #authenticate_or_request_with_http_basic('Site Message') do |username, password|
     #username == 'mtendem' && password == 'janomax1234Q!'
    #end
  #end

  ## == CancanCan ==
  # config.authorize_with :cancancan

  ## == Pundit ==
  # config.authorize_with :pundit
  ## == PaperTrail ==
  # config.audit_with :paper_trail, 'User', 'PaperTrail::Version' # PaperTrail >= 3.0.0

  ### More at https://github.com/sferik/rails_admin/wiki/Base-configuration

  ## == Gravatar integration ==
  ## To disable Gravatar integration in Navigation Bar set to false
  # config.show_gravatar = true

config.authorize_with :cancancan
config.current_user_method(&:current_user)

  config.actions do
    dashboard                     # mandatory
    index                         # mandatory
    new
    export
    bulk_delete
    show
    edit
    delete
    show_in_app

    ## With an audit adapter, you can add:
    # history_index
    # history_show
  end

  config.parent_controller = 'ApplicationController' 
end


