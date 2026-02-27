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
    edit do
      group :default do
        label "Основная информация"
        field :serial_number
        field :address
        field :description
        field :status do read_only true end
      end

      group :system_info do
        label "Системная информация"
        active false # Группа будет свернута по умолчанию
        field :board_name do read_only true end
        field :hw_rev do read_only true end
        field :fw_ver do read_only true end
        field :git_hash do read_only true end
      end

      group :peripherals do
        label "Периферия (Платежные системы)"
        active false
        field :billbox_sn do read_only true end
        field :billbox_name do read_only true end
        field :coinbox_sn do read_only true end
        field :coinbox_name do read_only true end
        field :cashless_sn do read_only true end
        field :cashless_name do read_only true end
      end
    end

    show do
      field :default do
        label "Общая информация"
        formatted_value do
          obj = bindings[:object]
          info = obj.status_info
          bootstrap_class = info[:class].gsub('label-', 'bg-')
          status = bindings[:view].content_tag(:span, info[:text], class: "badge #{bootstrap_class}").html_safe
          "
          <table class='table table-sm table-bordered' style='max-width: 500px;'>
            <tr><th class='bg-light' style='width: 40%'>Серийный номер</th><td>#{obj.serial_number}</td></tr>
            <tr><th class='bg-light'>Адрес</th><td>#{obj.address}</td></tr>
            <tr><th class='bg-light'>Описание</th><td>#{obj.description}</td></tr>
            <tr><th class='bg-light'>Состояние</th><td>#{status}</td></tr>
          </table>
          ".html_safe
        end
      end

      field :system_table do
        label "Системная информация"
        formatted_value do
          obj = bindings[:object]
          "
          <table class='table table-sm table-bordered' style='max-width: 500px;'>
            <tr><th class='bg-light' style='width: 40%'>Board Name</th><td>#{obj.board_name}</td></tr>
            <tr><th class='bg-light'>HW Rev</th><td>#{obj.hw_rev}</td></tr>
            <tr><th class='bg-light'>FW Ver</th><td>#{obj.fw_ver}</td></tr>
            <tr><th class='bg-light'>Git Hash</th><td><code>#{obj.git_hash}</code></td></tr>
          </table>
          ".html_safe
        end
      end

      field :peripherals_table do
        label "Платежное оборудование"
        formatted_value do
          obj = bindings[:object]
          "
          <table class='table table-sm table-striped' style='max-width: 600px;'>
            <thead>
              <tr><th>Устройство</th><th>Название</th><th>S/N</th></tr>
            </thead>
            <tbody>
              <tr><td><b>Billbox</b></td><td>#{obj.billbox_name}</td><td>#{obj.billbox_sn}</td></tr>
              <tr><td><b>Coinbox</b></td><td>#{obj.coinbox_name}</td><td>#{obj.coinbox_sn}</td></tr>
              <tr><td><b>Cashless</b></td><td>#{obj.cashless_name}</td><td>#{obj.cashless_sn}</td></tr>
            </tbody>
          </table>
          ".html_safe
        end
      end
    end

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
