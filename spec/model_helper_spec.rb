require 'spec_helper'

module Untied::Consumer::Sync::Backend::ActiveRecord
  describe ModelHelper do
    it_behaves_like 'a untied-consumer-sync backend'
  end
end
