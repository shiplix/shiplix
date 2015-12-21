# This file is used by Rack-based servers to start the application.

if defined?(Unicorn)
  require 'unicorn/worker_killer'

  # Max requests per worker
  max_requests_min = ENV['UNICORN_WORKER_KILLER_MAX_REQUESTS_MIN'] || 2500
  maw_requests_max = ENV['UNICORN_WORKER_KILLER_MAX_REQUESTS_MAX'] || 3000
  use Unicorn::WorkerKiller::MaxRequests, max_requests_min, maw_requests_max

  # Max memory size (RSS) per worker
  oom_min = (ENV['UNICORN_WORKER_KILLER_OOM_MIN'] || 300) * (1024**2)
  oom_max = (ENV['UNICORN_WORKER_KILLER_OOM_MAX'] || 350) * (1024**2)
  use Unicorn::WorkerKiller::Oom, oom_min, oom_max
end

require ::File.expand_path('../config/environment',  __FILE__)
run Rails.application
