module RailsAdmin
  module Config
    module Actions
      # common config for custom actions
      class Cmsaction < RailsAdmin::Config::Actions::Base
        register_instance_option :member do
          true
        end
        register_instance_option :only do
          [OrderAccount, Order, Account]
        end
        register_instance_option :visible? do
          authorized?
        end
        register_instance_option :controller do
          object = bindings[:object]
        end
      end

      class Pending < Cmsaction
        RailsAdmin::Config::Actions.register(self)
        register_instance_option :visible? do
          bindings[:object].document_missing? if bindings[:object].class == OrderAccount
        end

        register_instance_option :link_icon do
          "fa fa-pause-circle"
        end
        register_instance_option :controller do
          Proc.new do
            object.declare_pending!
            object.order.update_state
            flash[:notice] = "#{object.account.name} mis en attente"
            redirect_to show_path
          end
        end
      end
      class ResiliationSend < Cmsaction
        RailsAdmin::Config::Actions.register(self)
        register_instance_option :visible? do
          bindings[:object].pending? if bindings[:object].class == OrderAccount
        end
        register_instance_option :link_icon do
          'fa fa-location-arrow'
        end
        register_instance_option :controller do
          Proc.new do
            object.declare_resiliation_sent!
            flash[:notice] = "Demande de résiliation de #{object.account.name} envoyée"
            redirect_to show_path
          end
        end
      end
      class ResiliationSuccess < Cmsaction
        RailsAdmin::Config::Actions.register(self)
        register_instance_option :visible? do
          bindings[:object].resiliation_sent? if bindings[:object].class == OrderAccount
        end
        register_instance_option :link_icon do
          "fa fa-check-circle"
        end
        register_instance_option :controller do
          Proc.new do
            object.declare_resiliation_success!
            object.order.update_state
            flash[:notice] = "Résiliation de #{object.account.name} acceptée"
            redirect_to show_path
          end
        end
      end
      class ResiliationFailure < Cmsaction
        RailsAdmin::Config::Actions.register(self)
        register_instance_option :visible? do
          bindings[:object].resiliation_sent? if bindings[:object].class == OrderAccount
        end
        register_instance_option :link_icon do
          "fa fa-times-circle"
        end
        register_instance_option :controller do
          Proc.new do
            object.declare_resiliation_failure!
            object.order.update_state
            flash[:notice] = "Résiliation de #{object.account.name} échouée"
            redirect_to show_path
          end
        end
      end
      class Processing < Cmsaction
        RailsAdmin::Config::Actions.register(self)
        register_instance_option :visible? do
          bindings[:object].pending? if bindings[:object].class == Order
        end
        register_instance_option :link_icon do
          "fa fa-location-arrow"
        end
        register_instance_option :controller do
          Proc.new do
            object.declare_processing!
            flash[:notice] = "Résiliations de la démarche de #{object.deceased_first_name} #{object.deceased_last_name} en attente"
            redirect_to show_path
          end
        end
      end
      class Done < Cmsaction
        RailsAdmin::Config::Actions.register(self)
        register_instance_option :visible? do
          bindings[:object].processing? if bindings[:object].class == Order
        end
        register_instance_option :link_icon do
          "fa fa-check-circle"
        end
        register_instance_option :controller do
          Proc.new do
            object.declare_done!
            flash[:notice] = "Résiliations de la démarche de #{object.deceased_first_name} #{object.deceased_last_name} terminées"
            redirect_to show_path
          end
        end
      end
      class Validate < Cmsaction
        RailsAdmin::Config::Actions.register(self)
        register_instance_option :visible? do
          bindings[:object].non_validated? if bindings[:object].class == Account
        end
        register_instance_option :link_icon do
          "fa fa-check-circle"
        end
        register_instance_option :controller do
          Proc.new do
            object.validate!
            flash[:notice] = "Concessionnaire #{object.name} validé"
            redirect_to show_path
          end
        end
      end
    end
  end
end

RailsAdmin.config do |config|
  config.asset_source = :sprockets

  ### Popular gems integration

  ## == Devise ==
  config.authenticate_with do
    warden.authenticate! scope: :user
  end
  config.current_user_method(&:current_user)

  ## == CancanCan ==
  # config.authorize_with :cancancan

  ## == Pundit ==
  # config.authorize_with :pundit

  ## == PaperTrail ==
  # config.audit_with :paper_trail, 'User', 'PaperTrail::Version' # PaperTrail >= 3.0.0

  ### More at https://github.com/railsadminteam/rails_admin/wiki/Base-configuration

  ## == Gravatar integration ==
  ## To disable Gravatar integration in Navigation Bar set to false
  # config.show_gravatar = true

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
    pending
    resiliation_send
    resiliation_success
    resiliation_failure
    processing
    done
    validate

    ## With an audit adapter, you can add:
    # history_index
    # history_show

    ## == Personalized Non-Admin Alert
    config.authorize_with do
      unless current_user.admin?
        flash[:alert] = 'Vous devez être administrateur de eligia pour accéder à cette page'
        redirect_to main_app.root_path
      end
    end
  end
end
