FactoryBot.define do
  factory :analysis do
    user { nil }
    stock { nil }
    investor { nil }
    question { "MyText" }
    response { "MyText" }
    framework_data { "" }
    status { 1 }
    error_message { "MyText" }
    completed_at { "2025-11-04 18:42:33" }
  end
end
