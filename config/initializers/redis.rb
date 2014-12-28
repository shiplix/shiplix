unless Rails.env.test?
  filename = Rails.root.join('config', 'redis.yml').to_s
  conf = YAML.load(ERB.new(File.read(filename)).result).fetch(Rails.env.to_s).symbolize_keys

  redis = ::Redis.new(conf)
  Redis::Classy.db = redis
  Redis.current = redis
  Resque.redis = redis
  Resque.redis.namespace = 'shiplix'
end
