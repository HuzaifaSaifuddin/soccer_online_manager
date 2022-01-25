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
end
