require 'spec_helper'

describe User do
  it { should validate_uniqueness_of(:email) }
  it { should validate_presence_of(:username) }
  it "should validate uniqueness of username" do
    user1 = FactoryGirl.create(:user, username: "some_user")
    user2 = FactoryGirl.build(:user, username: "some_user")
    user2.should_not be_valid
  end
  
  it "should be valid given valid attributes" do
    user = FactoryGirl.build(:user)
    user.should be_valid
  end

  it "should not be valid given invalid password_confirmation" do
    user = FactoryGirl.build(:user, {password_confirmation: "not_correct"})
    user.should_not be_valid
  end
end
