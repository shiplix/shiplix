filename = Rails.root.join('config', 'memcache.yml').to_s
conf = YAML.load(ERB.new(File.read(filename)).result).fetch(Rails.env.to_s).symbolize_keys
servers = conf.delete(:servers)

Rails.application.config.cache_store = :dalli_store, servers, conf
