Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    # origins '*', '127.0.0.1:3001', 'regex-bc723.web.app'
    origins '127.0.0.1:3001', 'regex-bc723.web.app', 'regex-checker.com'
    resource '*', headers: :any, methods: [:get, :post, :patch, :put]
  end
end