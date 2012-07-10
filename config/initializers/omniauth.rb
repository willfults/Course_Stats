Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, '416897345029211', '3053a64960d3b3372baf144b3ba5969a'
  provider :linkedin, 'fc0yd5hs7ra3', 'oNyKLF8py2WVycoy'
end