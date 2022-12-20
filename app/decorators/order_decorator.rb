class OrderDecorator < ApplicationDecorator
  delegate_all

  def deceased_full_name
    "#{object.deceased_first_name} #{object.deceased_last_name}"
  end

  def deceased_cap_full_name
    "#{object.deceased_first_name} #{object.deceased_last_name.upcase}"
  end
end
