module AuthenticationMacros

  def fill_in_registration_form
    fill_in "user_email", with: valid_user.email
    fill_in "user_password", with: valid_user.password
    fill_in "user_password_confirmation", with: valid_user.password_confirmation
    fill_in "user_username", with: valid_user.username
  end

end
