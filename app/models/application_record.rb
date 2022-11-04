class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  def find_bucket
    case Rails.env
    when "development"
      "eligia_dev"
    when "staging"
      "eligia_staging"
    when "production"
      "eligia_prod"
    end
  end
end
