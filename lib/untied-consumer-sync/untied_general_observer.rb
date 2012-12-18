module Untied
  module Consumer
    module Sync
      # Observes all entities listed on config file
      class UntiedGeneralObserver < ObserverHelper
        def initialize
          super

          elements = self.config.values.collect {|v| v['name'].underscore.to_sym }
          args = elements << {:from => Sync.config.service_name }
          self.class.observe(*args)
        end

        def after_create(payload)
          kind = payload.keys[0]
          self.create_proxy(kind, payload.values[0])
        end

        def after_update(payload)
          kind = payload.keys[0]
          self.update_proxy(kind, payload.values[0])
        end

        def after_destroy(payload)
          kind = payload.keys[0]
          self.destroy_proxy(kind, payload.values[0])
        end
      end
    end
  end
end
