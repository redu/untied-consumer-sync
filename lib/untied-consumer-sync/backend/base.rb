module Untied
  module Consumer
    module Sync
      module Backend
        module Base
          @@instances = {}

          def self.included(base)
            base.extend ClassMethods
          end

          module ClassMethods
            def self.new(*args, &block)
              old_instance = @@instances[args[0]['name']]
              return old_instance if old_instance

              obj = ModelHelper.allocate
              obj.send(:initialize, *args, &block)
              @@instances[args[0]['name']] = obj

              obj
            end
          end
        end
      end
    end
  end
end