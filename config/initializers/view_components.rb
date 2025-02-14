# frozen_string_literal: true

Rails.application.configure do
  config.view_component.view_component_path = 'app/views/view_components'
  config.view_component.generate.sidecar = true
end
