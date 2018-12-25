Recaptcha.configure do |config|
  if Rails.env.production?
    config.site_key = Rails.application.credentials.dig(:recaptcha, :site_key)
    config.secret_key = Rails.application.credentials.dig(:recaptcha, :secret_key)
  else
    # these are fake keys for Recaptcha v2 that always pass
    # I suspect that these still only work if you're connected to the internet
    # since I usually develop offline, these may not do me much good
    config.site_key = '6LeIxAcTAAAAAJcZVRqyHh71UMIEGNQ_MXjiZKhI'
    config.secret_key = '6LeIxAcTAAAAAGG-vFI1TnRWxMZNFuojJ4WifJWe'
  end
end
