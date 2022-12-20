module HelpsHelper
  def format_french_date(date)
    l(Date.parse(date.to_s), format: :long)
  end
end
