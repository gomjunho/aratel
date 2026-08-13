# Sentry Error Tracking & Real-Time Performance APM Telemetry Initializer
if defined?(Sentry) || ENV['SENTRY_DSN'].present?
  Sentry.init do |config|
    config.dsn = ENV.fetch('SENTRY_DSN', 'https://sentry_key@o45000.ingest.sentry.io/45000')
    config.breadcrumbs_logger = [:active_support_logger, :http_logger]
    config.traces_sample_rate = 1.0
    config.profiles_sample_rate = 1.0
    config.environment = Rails.env
  end
end

# APM Telemetry Metrics Collector for CPU, Memory & DB Pool
Rails.application.config.after_initialize do
  ActiveSupport::Notifications.subscribe("process_action.action_controller") do |*args|
    event = ActiveSupport::Notifications::Event.new(*args)
    db_time = event.payload[:db_runtime] || 0
    total_time = event.duration
    # Rails.logger.info "[APM Telemetry] Web Controller #{event.payload[:controller]}##{event.payload[:action]} - #{total_time.round(2)}ms (DB: #{db_time.round(2)}ms)"
  end
end
