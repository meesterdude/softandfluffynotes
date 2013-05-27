require 'spec_helper'

describe "User Authentication" do
  before do
    @user = FactoryGirl.build(:user)
  end

  it "emails user confirmation token after signing up" do
    visit root_url
    click_link "Register"
    page.should have_content "Sign up"
    fill_in "user_email", with: @user.email
    fill_in "user_password", with: @user.password
    fill_in "user_password_confirmation", with: @user.password_confirmation
    fill_in "user_username", with: @user.username
    click_button "Sign up"
    last_email.to.should include(@user.email)
    last_email.body.should include(@user.confirmation_token)
  end

  it "allows user with valid confirmation token to confirm after signing up" do
    user = FactoryGirl.create(:user)
    user.should_not be_confirmed
    last_email.to.should include(user.email)
    last_email.body.should include(user.confirmation_token)
    visit user_confirmation_url(confirmation_token: user.confirmation_token)
    user.reload.should be_confirmed
  end

  it "does not allow user with invalid confirmation token to confirm" do
    visit user_confirmation_url(confirmation_token: 'invalid_token')
    page.should have_content(/Confirmation token(.*) invalid/)
  end

  context "with confirmation token expiry of 3 days" do
    before { Devise.confirm_within = 3.days  }
    it "should not allow user to confirm after 4 days" do
      user = FactoryGirl.create(:user)
      user.confirmation_sent_at = 4.days.ago
      user.save
      user.should_not be_confirmed
      visit user_confirmation_url(confirmation_token: user.confirmation_token)
      user.reload.should_not be_confirmed
    end
    it "should allow user to confirm after 2 days" do
      user = FactoryGirl.create(:user)
      user.confirmation_sent_at = 2.days.ago
      user.save
      user.should_not be_confirmed
      visit user_confirmation_url(confirmation_token: user.confirmation_token)
      user.reload.should be_confirmed
    end
  end

  context "with confirmed user" do
    before do
      @user = FactoryGirl.create(:user)
      @user.confirm!
    end
    it "allows valid user to log in" do
      visit new_user_session_url
      fill_in "user_email", with: @user.email
      fill_in "user_password", with: @user.password 
      click_button "Sign in"
      page.should have_content(/Logout/)
    end
  end
end
