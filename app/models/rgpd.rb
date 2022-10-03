class Rgpd < ApplicationRecord
  belongs_to :user, optional: true
end
