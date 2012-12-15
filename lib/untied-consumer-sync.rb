require "untied-consumer-sync/version"
require "untied-consumer-sync/config"
require "untied-consumer-sync/payload_proccessor"
require "untied-consumer-sync/model_helper"
require "untied-consumer-sync/observer_helper"
require "untied-consumer-sync/zombificator"

module Untied
  module Consumer
    module Sync
      def self.config
        @config ||= Config.new
      end

      # Configures untied-publisher. The options are defined at
      # lib/untied-consumer-sync/config.rb
      def self.configure(&block)
        yield(config) if block_given?

        if config.model_data.blank?
          raise "Configure where your yml file is."
        end
      end
    end
  end
end
