require 'spec_helper'

describe User do
  it { should validate_presence_of(:username) }
  it "should validate uniqueness of username" do
    user1 = FactoryGirl.create(:user, username: "some_user")
    user2 = FactoryGirl.build(:user, username: "some_user")
    user2.should have(1).error_on(:username)
  end
end
