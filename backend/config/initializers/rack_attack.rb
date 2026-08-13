class Rack::Attack
  # Rate limit identity verification to 5 requests per minute per IP
  throttle('identity_verify/ip', limit: 5, period: 1.minute) do |req|
    if req.path == '/api/v1/auth/identity_verify' && req.post?
      req.ip
    end
  end

  # Throttled response
  self.throttled_responder = lambda do |env|
    [
      429,
      { 'Content-Type' => 'application/json' },
      [{ error: 'Rate limit exceeded. Maximum 5 attempts per minute allowed.' }.to_json]
    ]
  end
end
