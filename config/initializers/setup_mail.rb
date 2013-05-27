ActionMailer::Base.smtp_settings = {
  address: "smtp.example.com",
  port: "587",
  domain: "fluffynotes.com",
  user_name: "fluffynotes",
  password: "secret",
  authentication: "plain",
  enable_starttls_auto: true
}
