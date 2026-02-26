RailsAdmin.config do |config|
  config.asset_source = :sprockets

  ### Popular gems integration

  config.parent_controller = 'ApplicationController'

  config.authenticate_with do
    authenticate_device!
  end 
  ## == Devise ==
  # config.authenticate_with do
  #   warden.authenticate! scope: :user
  # end
  # config.current_user_method(&:current_user)

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

    show_in_app do
      visible true
      controller do
        proc do
          # Rails сама соберет путь /api/v1/название_модели/id
          # format: :json добавит расширение в конец
          path = main_app.polymorphic_path([:api, :v1, @object], format: :json) rescue nil
        
          if path
            redirect_to path
          else
            # Если для модели нет API роута, просто открываем стандартный путь
            redirect_to main_app.url_for(@object)
          end
        end
      end
    end

    ## With an audit adapter, you can add:
    # history_index
    # history_show
  end

  config.model 'Device' do
    list do
      field :serial_number
      field :address
      # Кастомное поле для статуса
      field :status_display do
        label "Состояние связи"
        pretty_value do
          info = bindings[:object].status_info
          bootstrap_class = info[:class].gsub('label-', 'bg-')
          bindings[:view].content_tag(:span, info[:text], class: "badge #{bootstrap_class}")
        end
      end
      field :heartbeat_time do
        label "Последний сигнал"
        pretty_value do
          bindings[:object].heartbeat&.last_seen_at&.strftime("%d.%m %H:%M") || "—"
        end
      end

    end
  end
end
