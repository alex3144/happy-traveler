SacsRuby.configure do |config|
 config.user_id = ENV["SABRE_API_ID"] # User ID
 config.group = 'DEVCENTER' # Group
 config.domain = 'EXT' # Domain
 config.client_secret = ENV["SABRE_API_SECRET"]  # Client Secret
 config.environment = 'https://api.test.sabre.com' # Environment
 config.token_strategy = :single # or :shared - see Token paragraph
end



