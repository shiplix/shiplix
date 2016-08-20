if !Rails.env.test? && !ENV['ASSETS_PRECOMPILE']
  redis = ::Redis.new(url: ENV.fetch("SHIPLIX_REDIS_URL"))
  RedisClassy.redis = redis
  Redis.current = redis
  Resque.redis = redis
  Resque.redis.namespace = 'shiplix'


  cache_namespace = ENV.fetch('SHIPLIX_REDIS_CACHE_NAMESPACE', "shiplix").dup
  if File.exists?(Rails.root.join('REVISION'))
    rev = File.read(Rails.root.join('REVISION')).strip[0..3]
    cache_namespace << "_#{rev}" if rev.present?
  end

  Rails.application.config.cache_store = :readthis_store, {
    expires_in: 1.day.to_i,
    namespace: cache_namespace,
    redis: {url: ENV.fetch("SHIPLIX_CACHE_URL")}
  }
end
