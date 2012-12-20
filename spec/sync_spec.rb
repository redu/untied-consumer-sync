require 'spec_helper'

module Untied::Consumer
  describe Sync do
    describe '.configure' do
      it 'calls init_untied' do
        Sync.should_receive(:init_untied)
        Sync.configure
      end
    end

    describe '.model_data' do
      it 'returns the read yml' do
        Sync.model_data.should == {
                                     'User' => {
                                       'attributes' => ['login', 'name', 'id'],
                                       'mappings' => { 'id' => 'my_id' },
                                       'name' => 'User'
                                     },
                                     'Toy' => {
                                       'attributes' => ['user_id', 'id'],
                                       'mappings' => { 'id' => 'my_id' },
                                       'check_for' => { 'User' => 'user_id' },
                                       'name' => 'Toy'
                                     },
                                  }
      end
    end

    describe '.backend=' do
      before do
        Sync.backend = nil
      end

      after do
        Sync.backend = :active_record
      end

      let(:klass) { Class.new }

      it 'sets backend to klass' do
        Sync.backend = klass
        Sync.backend.should == klass
      end

      it 'sets backend using symbol' do
        Sync.backend = :active_record
        Sync.backend.to_s.should == "#{Sync}::Backend::ActiveRecord" \
          "::ModelHelper"
      end
    end
  end
end
