require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of(:username) }
  it { should validate_presence_of(:password_digest) }
  it { should validate_presence_of(:session_token) }
  it { should validate_length_of(:password).is_at_least(6) }
  it { should have_many(:comments) }
  it { should have_many(:goals) }

  subject(:user) do
    User.create!(
      username: "gerald",
      password: "super_secret_password"
    )
  end

  feature 'find users by creds' do
    User.create!(username: 'Alexina', password: 'secure_password')

    scenario 'with valid creds' do
      user = User.find_by_username('Alexina')
      expect(user.password).not_to be('secure_password')
    end

    scenario 'without valid creds' do
      expect(BCrypt::Password).to receive(:create)
      User.new(username: "andrew", password: "ffffffff")
    end
  end

end
