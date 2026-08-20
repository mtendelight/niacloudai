# config/initializers/request_logger.rb
class RequestLogger
  def initialize(app)
    @app = app
  end

  def call(env)
    start = Time.now
    status, headers, response = @app.call(env)
    duration = (Time.now - start) * 1000

    RequestLog.create!(
      path: env["PATH_INFO"],
      duration: duration,
      status: status
    ) if duration > 500

    [status, headers, response]
  end
end