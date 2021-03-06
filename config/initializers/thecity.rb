if  ENV['THECITY_APP_SECRET'].present?
  THECITY_APP_ID = ENV['THECITY_APP_ID']
  THECITY_APP_SECRET = ENV['THECITY_APP_SECRET']
  THECITY_AUTH_URL = ENV['THECITY_AUTH_URL']
else
  THECITY_CONFIG = YAML.load_file("#{::Rails.root}/config/thecity.yml")[::Rails.env]
  THECITY_APP_ID = THECITY_CONFIG['THECITY_APP_ID']
  THECITY_APP_SECRET = THECITY_CONFIG['THECITY_APP_SECRET']
  THECITY_AUTH_URL = THECITY_CONFIG['THECITY_AUTH_URL']
  ENV['THECITY_API_ENDPOINT'] = THECITY_CONFIG['THECITY_API_ENDPOINT']

end