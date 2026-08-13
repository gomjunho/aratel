# Configure session cookie security flags (SameSite=Strict, HttpOnly, Secure)
Rails.application.config.session_store :cookie_store,
  key: '_aratel_session',
  same_site: :strict,
  secure: Rails.env.production?,
  httponly: true

# Ensure ActionDispatch cookies set SameSite=Strict and HttpOnly in production
Rails.application.config.action_dispatch.default_headers.merge!(
  'X-Frame-Options' => 'DENY',
  'X-Content-Type-Options' => 'nosniff',
  'X-XSS-Protection' => '1; mode=block',
  'Referrer-Policy' => 'strict-origin-when-cross-origin'
)
