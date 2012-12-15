# -*- encoding : utf-8 -*-
require 'configurable'

module Untied
 module Consumer
   module Sync
     class Config
       include Configurable

       config :model_data, ""
     end
   end
 end
end
