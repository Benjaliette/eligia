FactoryBot.define do
  factory :delivery do
    order_account { nil }
  end

  factory :merci_facteur do
    access_token { "MyString" }
  end

  # factory :blogpost do
  #   title { "MyString" }
  #   body { "MyText" }
  # end

  factory :address do
    street { "9 rue André Darbon" }
    zip { "33000" }
    city { "Bordeaux" }
    state { "France" }
  end

  factory :rgpd do
    text { "MyString" }
    user
  end

  factory :cgs do
    text { "MyText" }
    user
  end

  factory :notification do
    content { "MyString" }
    order { nil }
  end

  # User
  factory :user do
    first_name { "John" }
    last_name  { "Doe" }
    email { "#{first_name}.#{last_name}@eligia.fr".downcase }
    admin { false }
    address { "7 rue Flornoy , 33000 Bordeaux , FR" }
    birthdate { Date.today - 20.year }
    password { "123456" }
    accepted_rgpd { true }
    accepted_cgs { true }
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

  # Account
  factory :account do
    subcategory
    sequence :name do |n|
      "accountName#{n}"
    end
    aasm_state { "validated" }
  end

  # Document
  factory :document do
    sequence :name do |n|
      "documentName#{n}"
    end
    format { "file" }
  end

  # Account_document
  factory :account_document do
    account
    document
  end

  # Order_document
  factory :order_document do
    order
    document
    document_input { nil }
  end

  # Pack
  factory :pack do
    sequence :title do |n|
      "packTitle#{n}"
    end
    price { 100 }
    sequence :level do |n|
      n
    end
  end

  # Order_accounts
  factory :order_account do
    order
    account
    aasm_state { "document_missing" }
  end

  # Order
  factory :order do
    user
    pack
    user_email {"jane.doe@eligia.fr"}
    deceased_first_name { "Jane" }
    deceased_last_name { "Doe" }
    aasm_state { "pending" }
  end
end
