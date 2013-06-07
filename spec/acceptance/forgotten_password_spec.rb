require 'spec_helper'
require 'acceptance_helper'

feature "Forgotten password handling" do
  include AuthenticationMacros
  include EmailSpec::Helpers
  include EmailSpec::Matchers

  let(:valid_user) { FactoryGirl.create(:user, confirmed_at: Time.now) }

  scenario "User goes through forgotten password process" do
    #visit root_url
    visit notes_index_url
    click_link("Login")
    click_link("Forgot your password?")
    page.should have_button("Send Reset E-mail")
    fill_in "Email", with: valid_user.email
    click_button("Send Reset E-mail")
    last_email.to.should include(valid_user.email)
    click_first_link_in_email(last_email)
    valid_user.password = "supersecret"
    fill_in "New password", with: valid_user.password
    fill_in "Confirm your new password", with: valid_user.password
    click_button "Change my password"
    page.should have_link("Logout")
  end

end
