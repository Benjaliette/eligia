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
    name { "categoryName" }
  end

  # Subcategory
  factory :subcategory do
    category
    name { "subcategoryName" }
  end

  # Accounts
  factory :account do
    category
    name { "accountName" }
    status { "non-validated" }
  end
end
