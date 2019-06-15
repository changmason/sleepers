FactoryBot.define do
  factory :sleep do
    uuid { SecureRandom.uuid }
    slept_at { "2019-06-15 23:55:00" }
    waked_at { "2019-06-16 08:00:00" }
  end
end
