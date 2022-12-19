require 'carrierwave/storage/fog'

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

CarrierWave.configure do |config|
  config.storage                             = :gcloud
  config.gcloud_bucket                       = find_bucket
  config.gcloud_bucket_is_public             = true
  config.gcloud_authenticated_url_expiration = 600

  config.gcloud_attributes = {
    expires: 600
  }

  config.gcloud_credentials = {
    gcloud_project: 'argon-works-363014',
    gcloud_keyfile: ENV['GOOGLE_APPLICATION_CREDENTIALS'].as_json
  }

  config.storage = :fog
end
