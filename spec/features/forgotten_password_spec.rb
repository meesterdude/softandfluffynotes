require 'spec_helper'

feature "Forgotten password handling" do
  include AuthenticationMacros

  let(:valid_user) {
    user = FactoryGirl.create(:user)
    user.confirm!
    return user
  }

  scenario "User goes through forgotten password process" do
    visit new_user_session_url
    click_link("Forgot your password?")
    page.should have_button("Send me reset password instructions")
    fill_in "user_email", with: valid_user.email
    click_button("Send me reset password instructions")
    last_email.to.should include(valid_user.email)
    valid_user.reload
    link = Capybara.string(last_email.body.encoded).find_link('Change my password')[:href]
    link.should have_content(valid_user.reset_password_token)
    visit link
    valid_user.password = "supersecret"
    fill_in "New password", with: valid_user.password
    fill_in "Confirm your new password", with: valid_user.password
    click_button "Change my password"
    page.should have_link("Logout")
    click_link "Logout"
    sign_in(valid_user)
    page.should have_link("Logout")
  end

end
