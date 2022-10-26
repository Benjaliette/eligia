Mollie::Client.configure do |config|
  config.api_key = ENV['MOLLIE_API_KEY']
  # Timeouts (default - 60)
  # config.open_timeout = 60
  # config.read_timeout = 60
end
