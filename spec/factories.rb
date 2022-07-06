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
    sequence :name do |n|
      "categoryName#{n}"
    end
  end

  # Subcategory
  factory :subcategory do
    category
    sequence :name do |n|
      "subcategoryName#{n}"
    end
  end

  # Accounts
  factory :account do
    subcategory
    sequence :name do |n|
      "accountName#{n}"
    end
    status { "non-validated" }
  end

  # Document
  factory :document do
    sequence :name do |n|
      "documentName#{n}"
    end
    format { "pdf" }
  end
end
