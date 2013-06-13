require 'acceptance_helper'

feature "Forgotten password handling" do
  include EmailSpec::Helpers

  let(:valid_user) { FactoryGirl.create(:user, confirmed_at: Time.now) }

  scenario "User goes through forgotten password process" do
    visit notes_index_url
    click_link("Login")
    click_link("Forgot your password?")
    page.should have_button("Send Reset E-mail")
    fill_in "Email", with: valid_user.email
    click_button("Send Reset E-mail")
    last_email.to.should include(valid_user.email)
    click_first_link_in_email(last_email)
    fill_in "New password", with: valid_user.password + "a"
    fill_in "Confirm your new password", with: valid_user.password + "a"
    click_button "Change my password"
    page.should have_link("Logout")
  end

end
