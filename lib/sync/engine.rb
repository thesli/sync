module Sync

  class Engine < Rails::Engine
    # Loads the sync.yml file if it exists.
    initializer "sync.config", group: :all do
      path = Rails.root.join("config/sync.yml")
      Sync.load_config(path, Rails.env) if path.exist?
    end

    initializer "sync.event_machine" do
      Sync.reactor.start if Sync.async?
    end

    initializer "sync.activerecord" do
      ActiveRecord::Base.send :extend, Model::ClassMethods
    end

    # Adds the ViewHelpers into ActionView::Base
    initializer "sync.view_helpers" do
      ActionView::Base.send :include, ViewHelpers
    end

    # Adds the ControllerHelpers into ActionConroller::Base
    initializer "sync.controller_helpers" do
      ActionController::Base.send :include, Sync::ControllerHelpers
    end
  end
end
