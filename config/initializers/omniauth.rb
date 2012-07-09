Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, '435627559802890', 'c9fe40dc142b620f550e8c4293898101'
  provider :linkedin, 'fc0yd5hs7ra3', 'oNyKLF8py2WVycoy'
end