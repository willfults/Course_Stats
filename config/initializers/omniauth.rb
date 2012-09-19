Rails.application.config.middleware.use OmniAuth::Builder do
  $FACEBOOK_APP_ID = '416897345029211'
  $FACEBOOK_APP_SECRET = '3053a64960d3b3372baf144b3ba5969a'
  provider :facebook, $FACEBOOK_APP_ID, $FACEBOOK_APP_SECRET
  $LINKEDIN_APP_KEY = 'fc0yd5hs7ra3'
  $LINKEDIN_APP_SECRET = 'oNyKLF8py2WVycoy'
  provider :linkedin, $LINKEDIN_APP_KEY, $LINKEDIN_APP_SECRET
end