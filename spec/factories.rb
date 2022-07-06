FactoryBot.define do
  # User
  factory :user do
    first_name { "John" }
    last_name  { "Doe" }
    email { "#{first_name}.#{last_name}@eligia.fr".downcase }
    admin { false }
    password { "123456" }
  end

  # Category
  factory :category do
    name { "CategoryName" }
  end
end
