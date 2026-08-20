# config/puma.rb

max_threads_count = Integer(ENV.fetch("RAILS_MAX_THREADS", 5))
threads max_threads_count, max_threads_count

# Single Puma process — suitable for a 2 GB server
workers 0

preload_app!

environment ENV.fetch("RAILS_ENV", "production")

port ENV.fetch("PORT", 3000)

pidfile ENV.fetch("PIDFILE", "tmp/pids/server.pid")

plugin :tmp_restart

before_fork do
  ActiveRecord::Base.connection_pool.disconnect! if defined?(ActiveRecord)
end

on_worker_boot do
  ActiveRecord::Base.establish_connection if defined?(ActiveRecord)
end
