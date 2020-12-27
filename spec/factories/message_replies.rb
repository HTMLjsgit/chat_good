FactoryBot.define do
  factory :message_reply do
    content { "MyText" }
    against_user_id { 1 }
  end
end
