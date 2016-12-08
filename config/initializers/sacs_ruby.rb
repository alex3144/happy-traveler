SacsRuby.configure do |config|
  config.user_id = 'm36yharhmm5t377t' # User ID
  config.group = 'DEVCENTER' # Group
  config.domain = 'EXT' # Domain
  config.client_secret = '7VoSEy1m' # Client Secret
  config.environment = 'https://api.test.sabre.com' # Environment
  config.token_strategy = :single # or :shared - see Token paragraph
end
