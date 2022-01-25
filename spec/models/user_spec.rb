require 'rails_helper'

RSpec.describe User, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"

  it 'has a valid factory' do
    expect(build_stubbed(:user)).to be_valid
  end

  describe 'Validations' do
    it 'is invalid without a email' do
      expect(build_stubbed(:user, email: nil)).to be_invalid
    end

    it 'is invalid if the email is taken' do
      user = create(:user)
      expect(build_stubbed(:user, email: user.email)).to be_invalid
    end

    it 'is invalid if the email has incorrect format' do
      expect(build_stubbed(:user, email: 'incorrect-email')).to be_invalid
    end

    it 'is invalid without a password while creating record' do
      user = build(:user, password: nil)
      expect(user.save).to be_falsy
    end

    it 'is invalid if password length is < 8' do
      user = build(:user, password: 'short')
      expect(user.save).to be_falsy
    end

    it 'is valid without a password while updating record' do
      user = create(:user)
      expect(user.update(password: nil)).to be_truthy
    end
  end

  describe 'self.authenticate' do
    it 'authenticates user' do
      user = create(:user)
      user.send(:encrypt_password)

      auth_user = User.authenticate(user.email, user.password)
      expect(auth_user).to_not eq(nil)
    end

    it 'fails authentication if email is incorrect' do
      auth_user = User.authenticate(Faker::Internet.email, 'Password')

      expect(auth_user).to eq(nil)
    end

    it 'fails authentication if email is not present' do
      auth_user = User.authenticate('', 'Password')
      expect(auth_user).to eq(nil)
    end

    it 'fails authentication if password is not present' do
      auth_user = User.authenticate(Faker::Internet.email, '')
      expect(auth_user).to eq(nil)
    end

    it 'fails authentication if password is incorrect' do
      user = create(:user)
      user.send(:encrypt_password)

      auth_user = User.authenticate(user.email, 'Incorrect Password')

      expect(auth_user).to eq(nil)
    end
  end

  describe 'match_password' do
    it 'validates password with salt' do
      user = create(:user)
      password = user.password
      user.send(:encrypt_password)

      expect(user.match_password(password)).to be_truthy
    end

    it 'fails validation when password is incorrect' do
      user = create(:user)
      user.send(:encrypt_password)

      expect(user.match_password('Incorrect Password')).to be_falsy
    end
  end

  describe 'encrypt_password' do
    it 'encrypts password with salt' do
      user = build(:user)
      user.send(:encrypt_password)

      expect(user.salt).to_not eq(nil)
    end

    it 'doesnt encrypted empty password' do
      user = build(:user, password: nil)
      user.send(:encrypt_password)

      expect(user.salt).to eq(nil)
    end
  end

  describe 'create_team' do
    it 'creates a team and 20 Players for the new user' do
      user = build(:user)
      user.send(:create_team)

      expect(user.team).to_not eq(nil)
      expect(user.team.players.count).to eq(20)
    end
  end
end
