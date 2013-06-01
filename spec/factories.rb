FactoryGirl.define do
  factory :user do
    sequence(:email) {|n| "user#{n}@example.com"}
    sequence(:username) {|n| "user#{n}"}
    password 'topsecret'
    password_confirmation {|u| u.password }
  end
end
