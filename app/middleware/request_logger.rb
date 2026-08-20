# app/middleware/request_logger.rb

class RequestLogger
  def initialize(app)
    @app = app
  end

  def call(env)
    start = Time.now
    status, headers, response = @app.call(env)
    duration = (Time.now - start) * 1000

    if defined?(RequestLog) && duration > 500
      RequestLog.create!(
        path: env["PATH_INFO"],
        duration: duration,
        status: status
      )
    end

    [status, headers, response]
  end
end