module AuthenticationMacros
  def sign_in(user, login_attr=:email)
    visit new_user_session_url
    fill_in "user_login", with: user.send(login_attr)
    fill_in "user_password", with: user.password 
    click_button "Sign in"
  end

  def fill_in_registration_form(user)
    fill_in "user_email", with: user.email
    fill_in "user_password", with: user.password
    fill_in "user_password_confirmation", with: user.password_confirmation
    fill_in "user_username", with: user.username
  end

end
