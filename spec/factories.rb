FactoryGirl.define do
  factory :user do
    email "user@example.com"
    username "user"
    password 'topsecret'
    password_confirmation 'topsecret'
  end
end
