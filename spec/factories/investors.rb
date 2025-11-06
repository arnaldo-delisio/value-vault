FactoryBot.define do
  factory :investor do
    name { "MyString" }
    persona { 1 }
    system_prompt { "MyText" }
    framework_config { "" }
    avatar_url { "MyString" }
    active { false }
    analyses_count { 1 }
  end
end
