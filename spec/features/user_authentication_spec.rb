require 'spec_helper'

feature "User Authentication" do
  include AuthenticationMacros

  let(:valid_user) { FactoryGirl.build(:user) }
  
  scenario "User goes through sign up steps and is able to sign in with email or username" do
    visit notes_index_url
    click_link "Register"
    fill_in_registration_form(valid_user)
    click_button "Sign up"
    last_email.to.should include(valid_user.email)
    valid_user.confirmation_token = User.find_by_email(valid_user.email).confirmation_token
    last_email.body.should include(valid_user.confirmation_token)
    visit new_user_session_url
    click_link "Didn't receive confirmation instructions?"
    fill_in "user_email", with: valid_user.email
    click_button "Resend confirmation instructions"
    last_email.to.should include(valid_user.email)
    last_email.body.should include(valid_user.confirmation_token)
    link = Capybara.string(last_email.body.encoded).find_link('Confirm my account')[:href]
    visit link.gsub("localhost:3000","localhost:#{Capybara.server_port}")
    page.should have_link('Logout')
    click_link "Logout"
    page.should have_link('Login')
    page.should have_content("Signed out successfully")
    sign_in(valid_user)
    page.should have_link('Logout')
    click_link "Logout"
    sign_in(valid_user, :username)
    page.should have_link('Logout')
  end

end
