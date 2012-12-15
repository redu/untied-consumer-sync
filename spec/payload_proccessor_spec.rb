require 'spec_helper'

module Untied::Consumer::Sync
  describe PayloadProccessor do
    let(:subject) { PayloadProccessor.new(config) }
    let(:config) do
      { 'attributes' => ['login', 'name', 'id'],
        'mappings' => { 'id' => 'my_id' },
        'name' => 'User' }
    end

    describe 'proccess' do
      let(:payload) {{"id"=> 22, 'login' => 'sexy_jedi_3000',
        'name' => 'Luke Skywalker','thingy' => 'aaaa', 'useless_thing' => 2}}

      it 'should translate mappings' do
        new_load = subject.proccess(payload)
        new_load.fetch("my_id", nil).should == payload["id"]
      end

      it 'should remove useless data' do
        new_load = subject.proccess(payload)
        new_load.fetch("useless_thing", nil).should be_nil
      end

      context "when there are no mappings" do
        let(:subject) do
          new_config = config.clone
          new_config.delete(:mappings)

          PayloadProccessor.new(new_config)
        end

        it "should not raise error" do
          expect {
            subject.proccess(payload)
          }.to_not raise_error
        end
      end
    end
  end
end
