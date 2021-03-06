shared_examples_for 'a untied-consumer-sync backend' do
  let(:subject) { described_class.new(user_config) }
  let(:user_payload) { { 'my_id'=> 22, 'login' => 'sexy_jedi_3000',
                 'name' => 'Luke Skywalker' } }
  let(:user_config) do
    {
      'attributes' => ['login', 'name', 'id'],
      'mappings' => { 'id' => 'my_id' },
      'name' => 'User'
    }
  end

  after do
    User.delete_all
  end

  describe '#find' do
    context 'when user does not exist yet' do
      it 'should not find object if it doesnt exist' do
        subject.find(3333).should be_nil
      end
    end

    context 'when user exists' do
      before do
        User.create do |u|
          u.my_id = 1
          u.login = 'luke'
        end
      end

      it 'should find object by id' do
        subject.find(1).should_not be_nil
      end
    end
  end

  describe '#create_zombie' do
    it 'should create zombie user' do
      subject.create_zombie(99)
      User.unscoped.where(:my_id => 99).should exist
      User.unscoped.where(:my_id => 99).first.should be_zombie
    end
  end

  describe '#create_model' do
    context "with valid payload" do
      context "when user does not exist yet" do
        it 'should create user' do
          subject.create_model(user_payload)
          User.where(:my_id => user_payload['my_id']).should exist
        end
      end

      context "when user exists" do
        before do
          User.unscoped.new(:my_id => user_payload['my_id']).
            save(:validate => false)
        end

        it 'should update zombie user' do
          subject.create_model(user_payload)
          User.where(:my_id => user_payload['my_id']).first.should be_valid
        end
      end
    end
  end

  describe '#update_model' do
    context 'when user does not exist yet' do
      it 'should create user' do
        subject.update_model(user_payload)
        User.where(:my_id => user_payload['my_id']).should exist
      end
    end

    context 'when user exists' do
      before do
        User.unscoped.new(:my_id => user_payload['my_id']).
          save(:validate => false)
      end

      it 'should update user on database' do
        subject.update_model(user_payload)
        User.where(:my_id => user_payload['my_id']).first.should be_valid
      end
    end
  end

  describe '#destroy_model' do
    context 'when user exists' do
      before do
        User.unscoped.new(:my_id => user_payload['my_id']).
          save(:validate => false)
      end

      it 'should delete from database' do
        subject.destroy_model(user_payload)
        User.where(:my_id => user_payload['my_id']).should_not exist
      end
    end
  end
end
