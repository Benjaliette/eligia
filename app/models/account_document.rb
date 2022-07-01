class AccountDocument < ApplicationRecord
  belongs_to :account
  belongs_to :document
end
