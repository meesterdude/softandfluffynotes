require 'spec_helper'
require 'acceptance_helper'

feature "User Authentication" do
  include AuthenticationMacros
  include EmailSpec::Helpers
  include EmailSpec::Matchers

  let(:valid_user) { FactoryGirl.build(:user) }
  
  scenario "User can sign up & sign in" do
    visit notes_index_url
    click_link "Register"
    fill_in_registration_form
    click_button "Sign up"
    last_email.to.should include(valid_user.email)
    click_first_link_in_email(last_email)
    page.should have_link('Logout')
    click_link "Logout"
    page.should have_content("Signed out successfully")
    page.should have_link('Login')
    sign_in(valid_user)
    page.should have_link('Logout')
  end

end
