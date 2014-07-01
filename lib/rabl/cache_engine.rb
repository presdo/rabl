# Defines the default cache engine for RABL when caching is invoked for a template.
# You can define your own caching engines by creating an object that responds to fetch and
# setting the configuration option:
#
#     config.cache_engine = AdvancedCacheEngine.new
#

module Rabl
  class CacheEngine

    # Fetch given a key and options and a fallback block attempts to find the key in the cache
    # and stores the block result in there if no key is found.
    #
    # cache = Rabl::CacheEngine.new; cache.fetch("some_key") { "fallback data" }
    #
    def fetch(key, cache_options, &block)
      if defined?(Rails)
        Rails.cache.fetch(key, cache_options, &block)
      else
        yield
      end
    end

    # We add this fetch_with_patch method to allow us to use cache in rabl while running rails 2 
    # (rails 3 does not need this b/c it is okay with passing in nil options whereas rails 2 is not)
    # https://github.com/nesquena/rabl/issues/325
    def fetch_with_patch(key, cache_options = {}, &block)
      cache_options ||= {}
      fetch_without_patch(key, cache_options, &block) #with the alias method chain this calls fetch defined above
    end
    alias_method_chain :fetch, :patch

  end
end
