# -*- encoding : utf-8 -*-
require 'configurable'

module Untied
 module Consumer
   module Sync
     class Config
       include Configurable

       # Config file with models (and its attributes) that will be sync
       config :model_data, ""
       # Publisher's identifier so Sync know where to listen.
       # Default: untied_publisher
       config :service_name, 'untied_publisher'
     end
   end
 end
end
