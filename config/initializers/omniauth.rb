Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, '416897345029211', '3053a64960d3b3372baf144b3ba5969a'
  $LINKEDIN_APP_KEY = 'fc0yd5hs7ra3'
  $LINKEDIN_APP_SECRET = 'oNyKLF8py2WVycoy'
  provider :linkedin, $LINKEDIN_APP_KEY, $LINKEDIN_APP_SECRET
end