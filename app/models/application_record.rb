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

  def set_attached_with_path
    case self
    when OrderAccount, OrderDocument
      order_namepath(self.order)
    when Order
      order_namepath(order)
    end
  end

  def order_namepath(order)
    "#{order.deceased_first_name.gsub(' ', '_')}_#{order.deceased_last_name.gsub(' ', '_')}"
  end
end
