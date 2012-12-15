require 'spec_helper'

module Untied::Consumer::Sync
  describe ObserverHelper do
    let(:subject){ ObserverHelper.instance }

    after do
      User.delete_all
    end

    context "#create_proxy" do
      context "with a complete (valid) User" do
        let(:user) { { 'id' => 1, 'login' => 'sexy_jedi_3000',
                       'name' => 'Luke Skywalker', :thingy => false } }

        it 'should return true' do
          subject.create_proxy("user", user).should == true
        end

        it "should add user to database" do
          expect{
            subject.create_proxy("user", user)
          }.to change(User, :count).by(1)
        end
      end

      context "with, for now, invalid references" do
        let(:toy) { { 'id' => 1, 'user_id' => 1 } }

        it 'should return true' do
          subject.create_proxy("toy", toy).should == true
        end

        it "should add toy to database" do
          expect{
            subject.create_proxy("toy", toy)
          }.to change(Toy, :count).by(1)
        end

        it "creates zombie entity for user_id" do
          subject.create_proxy("toy", toy)
          User.unscoped.find_by_my_id(toy['user_id']).should_not be_nil
        end

        after do
          Toy.delete_all
        end
      end

      context "with a invalid User" do
        let(:invalid_user) { { 'id' => 1 } }

        it "should return false" do
          subject.create_proxy("user", invalid_user).should be_false
        end

        it "shouldn't add user to database" do
          expect{
            subject.create_proxy("user", invalid_user)
          }.to_not change(User, :count)
        end
      end

      context "with a existent User zombie" do
        before do
          @user_zombie = User.new(:my_id => 1)
          @user_zombie.save(:validate => false)
        end
        let(:user) { { 'id' => 1, 'login' => 'sexy_jedi_3000',
                       'name' => 'Luke Skywalker' } }

        it 'should return true' do
          subject.create_proxy("user", user).should be_true
        end

        it 'should complete User zombie' do
          subject.create_proxy("user", user)
          @user_zombie.reload
          @user_zombie.login.should == user['login']
          @user_zombie.name.should == user['name']
        end
      end
    end

    context "#update_proxy" do
      let(:updated_user) { { 'id' => 1, 'login' => 'sexy_jedi_3000',
                             'name' => 'Luke Vader' } }
      before do
        @user = User.create(:my_id => 1, :login => "sexy_jedi_3000",
                            :name => "Luke Skywalker")
      end

      it "should return true" do
        subject.update_proxy("user", updated_user).should be_true
      end

      it "should update user on database" do
        subject.update_proxy("user", updated_user)
        @user.reload
        @user.name.should == updated_user['name']
      end
    end

    context "#destroy_proxy" do
      let(:destroyed_user) { { 'id' => 1, 'login' => 'sexy_jedi_3000',
                             'name' => 'Luke Skywalker' } }
      before do
        @user = User.create(:my_id => 1, :login => "sexy_jedi_3000",
                            :name => "Luke Skywalker")
      end

      it "should return true" do
        subject.destroy_proxy("user", destroyed_user).should be_true
      end

      it "should erase user from database" do
        subject.destroy_proxy("user", destroyed_user)
        expect {
          @user.reload
        }.to raise_error
      end
    end
  end
end
