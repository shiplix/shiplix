require 'resque/tasks'

namespace :resque do
  task :setup => :environment do
    Resque.logger.level = 1
    Resque.logger.formatter = Resque::VeryVerboseFormatter.new

    Resque.before_first_fork do
      ActiveRecord::Base.connection_handler.clear_all_connections!
      Rails.cache.reset if Rails.cache.respond_to?(:reset)
    end

    Resque.before_fork do
      Resque.redis.client.disconnect
    end

    Resque.after_fork do |job|
      $0 = "resque-#{Resque::Version}: Processing #{job.queue}/#{job.payload['class']} since #{Time.now.to_s(:db)}"

      ActiveRecord::Base.clear_active_connections!

      Resque.redis.client.connect
    end
  end
end
