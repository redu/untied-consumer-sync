require 'spec/spec_helper'

module Untied::Consumer::Sync
  describe UntiedGeneralObserver do
    let(:subject) { UntiedGeneralObserver.instance }

    describe ".initialize" do
      before do
        subject
      end

      # Observed classes defined at spec/support/model_data.yml
      it "should define observed classes" do
        subject.observed_classes.to_set.should == [:toy, :user].to_set
      end

      # Observed service name defined at spec_helper
      it "should define observed service" do
        subject.observed_service.should == :my_service
      end
    end

    describe "#after_create" do
      it "should call create_proxy with kind and payload" do
        subject.should_receive(:create_proxy).with('user', { 'id' => 1})
        subject.after_create({ 'user' => { 'id' => 1} })
      end
    end

    describe "#after_update" do
      it "should call update_proxy with kind and payload" do
        subject.should_receive(:update_proxy).with('user', { 'id' => 1})
        subject.after_update({ 'user' => { 'id' => 1} })
      end
    end

    describe "#after_destroy" do
      it "should call destroy_proxy with kind and payload" do
        subject.should_receive(:destroy_proxy).with('user', { 'id' => 1})
        subject.after_destroy({ 'user' => { 'id' => 1} })
      end
    end
  end
end
