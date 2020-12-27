FactoryBot.define do
  factory :notification do
    action { "MyString" }
    visitor { nil }
    visited { nil }
  end
end
