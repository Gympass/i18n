require 'set'

module I18n
  class Config
    # The only configuration value that is not global and scoped to thread is :locale.
    # It defaults to the default_locale.
    def locale
      @locale ||= default_locale
    end

    # Sets the current locale pseudo-globally, i.e. in the Thread.current hash.
    def locale=(locale)
      I18n.enforce_available_locales!(locale)
      @locale = locale && locale.to_sym
    end

    # Returns the current backend. Defaults to +Backend::Simple+.
    def backend
      @@backend ||= Backend::Simple.new
    end

    # Sets the current backend. Used to set a custom backend.
    def backend=(backend)
      @@backend = backend
    end

    # Returns the current default locale. Defaults to :'en'
    def default_locale
      @@default_locale ||= :en
    end

    # Sets the current default locale. Used to set a custom default locale.
    def default_locale=(locale)
      I18n.enforce_available_locales!(locale)
      @@default_locale = locale && locale.to_sym
    end

    # Returns an array of locales for which translations are available.
    # Unless you explicitely set these through I18n.available_locales=
    # the call will be delegated to the backend.
    def available_locales
      @@available_locales ||= nil
      @@available_locales || backend.available_locales
    end

    # Caches the available locales list as both strings and symbols in a Set, so
    # that we can have faster lookups to do the available locales enforce check.
    def available_locales_set #:nodoc:
      @@available_locales_set ||= available_locales.inject(Set.new) do |set, locale|
        set << locale.to_s << locale.to_sym
      end
    end

    # Sets the available locales.
    def available_locales=(locales)
      @@available_locales = Array(locales).map { |locale| locale.to_sym }
      @@available_locales = nil if @@available_locales.empty?
      @@available_locales_set = nil
    end

    # Clears the available locales set so it can be recomputed again after I18n
    # gets reloaded.
    def clear_available_locales_set #:nodoc:
      @@available_locales_set = nil
    end

    # Returns the current default scope separator. Defaults to '.'
    def default_separator
      @@default_separator ||= '.'
    end

    # Sets the current default scope separator.
    def default_separator=(separator)
      @@default_separator = separator
    end

    # Returns the current exception handler. Defaults to an instance of
    # I18n::ExceptionHandler.
    def exception_handler
      @@exception_handler ||= ExceptionHandler.new
    end

    # Sets the exception handler.
    def exception_handler=(exception_handler)
      @@exception_handler = exception_handler
    end

    # Returns the current handler for situations when interpolation argument
    # is missing. MissingInterpolationArgument will be raised by default.
    def missing_interpolation_argument_handler
      @@missing_interpolation_argument_handler ||= lambda do |missing_key, provided_hash, string|
        raise MissingInterpolationArgument.new(missing_key, provided_hash, string)
      end
    end

    # Sets the missing interpolation argument handler. It can be any
    # object that responds to #call. The arguments that will be passed to #call
    # are the same as for MissingInterpolationArgument initializer. Use +Proc.new+
    # if you don't care about arity.
    #
    # == Example:
    # You can supress raising an exception and return string instead:
    #
    #   I18n.config.missing_interpolation_argument_handler = Proc.new do |key|
    #     "#{key} is missing"
    #   end
    def missing_interpolation_argument_handler=(exception_handler)
      @@missing_interpolation_argument_handler = exception_handler
    end

    # Allow clients to register paths providing translation data sources. The
    # backend defines acceptable sources.
    #
    # E.g. the provided SimpleBackend accepts a list of paths to translation
    # files which are either named *.rb and contain plain Ruby Hashes or are
    # named *.yml and contain YAML data. So for the SimpleBackend clients may
    # register translation files like this:
    #   I18n.load_path << 'path/to/locale/en.yml'
    def load_path
      @@load_path ||= []
    end

    # Sets the load path instance. Custom implementations are expected to
    # behave like a Ruby Array.
    def load_path=(load_path)
      @@load_path = load_path
    end

    # Whether or not to verify if locales are in the list of available locales.
    # Defaults to true.
    @@enforce_available_locales = true
    def enforce_available_locales
      @@enforce_available_locales
    end

    def enforce_available_locales=(enforce_available_locales)
      @@enforce_available_locales = enforce_available_locales
    end
    
    def country
      @country ||= default_country
    end

    # Sets the current country pseudo-globally, i.e. in the Thread.current hash.
    def country=(country)
      I18n.enforce_available_countries!(country)
      @country = country && country.to_sym
    end

    # Returns the current default country. Defaults to :'en'
    def default_country
      @@default_country ||= :us
    end

    # Sets the current default country. Used to set a custom default country.
    def default_country=(country)
      I18n.enforce_available_countries!(country)
      @@default_country = country && country.to_sym
    end

    # Returns an array of countries for which translations are available.
    # Unless you explicitely set these through I18n.available_countries=
    # the call will be delegated to the backend.
    def available_countries
      @@available_countries ||= nil
      @@available_countries || backend.available_countries
    end

    # Caches the available countries list as both strings and symbols in a Set, so
    # that we can have faster lookups to do the available countries enforce check.
    def available_countries_set #:nodoc:
      @@available_countries_set ||= available_countries.inject(Set.new) do |set, country|
        set << country.to_s << country.to_sym
      end
    end

    # Sets the available countries.
    def available_countries=(countries)
      @@available_countries = Array(countries).map { |country| country.to_sym }
      @@available_countries = nil if @@available_countries.empty?
      @@available_countries_set = nil
    end

    # Clears the available countries set so it can be recomputed again after I18n
    # gets reloaded.
    def clear_available_countries_set #:nodoc:
      @@available_countries_set = nil
    end

    # Whether or not to verify if countries are in the list of available countries.
    # Defaults to true.
    @@enforce_available_countries = true
    def enforce_available_countries
      @@enforce_available_countries
    end

    def enforce_available_countries=(enforce_available_countries)
      @@enforce_available_countries = enforce_available_countries
    end
    
    def site
      @site ||= default_site
    end

    # Sets the current site pseudo-globally, i.e. in the Thread.current hash.
    def site=(site)
      I18n.enforce_available_sites!(site)
      @site = site && site.to_i
    end

    # Returns the current default site. Defaults to :'en'
    def default_site
      @@default_site ||= 1
    end

    # Sets the current default site. Used to set a custom default site.
    def default_site=(site)
      I18n.enforce_available_sites!(site)
      @@default_site = site && site.to_i
    end

    # Returns an array of sites for which translations are available.
    # Unless you explicitely set these through I18n.available_sites=
    # the call will be delegated to the backend.
    def available_sites
      @@available_sites ||= nil
      @@available_sites || backend.available_sites
    end

    # Caches the available sites list as both strings and symbols in a Set, so
    # that we can have faster lookups to do the available sites enforce check.
    def available_sites_set #:nodoc:
      @@available_sites_set ||= available_sites.inject(Set.new) do |set, site|
        set << site.to_s << site.to_i
      end
    end

    # Sets the available sites.
    def available_sites=(sites)
      @@available_sites = Array(sites).map { |site| site.to_i }
      @@available_sites = nil if @@available_sites.empty?
      @@available_sites_set = nil
    end

    # Clears the available sites set so it can be recomputed again after I18n
    # gets reloaded.
    def clear_available_sites_set #:nodoc:
      @@available_sites_set = nil
    end

    # Whether or not to verify if sites are in the list of available sites.
    # Defaults to true.
    @@enforce_available_sites = true
    def enforce_available_sites
      @@enforce_available_sites
    end

    def enforce_available_sites=(enforce_available_sites)
      @@enforce_available_sites = enforce_available_sites
    end      

    def bu
      @bu ||= default_bu
    end

    # Sets the current bu pseudo-globally, i.e. in the Thread.current hash.
    def bu=(bu)
      I18n.enforce_available_bus!(bu)
      @bu = bu && bu.to_i
    end

    # Returns the current default bu. Defaults to :'en'
    def default_bu
      @@default_bu ||= 1
    end

    # Sets the current default bu. Used to set a custom default bu.
    def default_bu=(bu)
      I18n.enforce_available_bus!(bu)
      @@default_bu = bu && bu.to_i
    end

    # Returns an array of bus for which translations are available.
    # Unless you explicitely set these through I18n.available_bus=
    # the call will be delegated to the backend.
    def available_bus
      @@available_bus ||= nil
      @@available_bus || backend.available_bus
    end

    # Caches the available bus list as both strings and symbols in a Set, so
    # that we can have faster lookups to do the available bus enforce check.
    def available_bus_set #:nodoc:
      @@available_bus_set ||= available_bus.inject(Set.new) do |set, bu|
        set << bu.to_s << bu.to_i
      end
    end

    # Sets the available bus.
    def available_bus=(bus)
      @@available_bus = Array(bus).map { |bu| bu.to_i }
      @@available_bus = nil if @@available_bus.empty?
      @@available_bus_set = nil
    end

    # Clears the available bus set so it can be recomputed again after I18n
    # gets reloaded.
    def clear_available_bus_set #:nodoc:
      @@available_bus_set = nil
    end

    # Whether or not to verify if bus are in the list of available bus.
    # Defaults to true.
    @@enforce_available_bus = true
    def enforce_available_bus
      @@enforce_available_bus
    end

    def enforce_available_bus=(enforce_available_bus)
      @@enforce_available_bus = enforce_available_bus
    end      
    
    def version
      @version ||= default_version
    end

    # Sets the current version pseudo-globally, i.e. in the Thread.current hash.
    def version=(version)
      I18n.enforce_available_versions!(version)
      @version = version && version.to_i
    end

    # Returns the current default version. Defaults to :'en'
    def default_version
      @@default_version ||= 1
    end

    # Sets the current default version. Used to set a custom default version.
    def default_version=(version)
      I18n.enforce_available_versions!(version)
      @@default_version = version && version.to_i
    end

    # Returns an array of versions for which translations are available.
    # Unless you explicitely set these through I18n.available_versions=
    # the call will be delegated to the backend.
    def available_versions
      @@available_versions ||= nil
      @@available_versions || backend.available_versions
    end

    # Caches the available versions list as both strings and symbols in a Set, so
    # that we can have faster lookups to do the available versions enforce check.
    def available_versions_set #:nodoc:
      @@available_versions_set ||= available_versions.inject(Set.new) do |set, version|
        set << version.to_s << version.to_i
      end
    end

    # Sets the available versions.
    def available_versions=(versions)
      @@available_versions = Array(versions).map { |version| version.to_i }
      @@available_versions = nil if @@available_versions.empty?
      @@available_versions_set = nil
    end

    # Clears the available versions set so it can be recomputed again after I18n
    # gets reloaded.
    def clear_available_versions_set #:nodoc:
      @@available_versions_set = nil
    end

    # Whether or not to verify if versions are in the list of available versions.
    # Defaults to true.
    @@enforce_available_versions = true
    def enforce_available_versions
      @@enforce_available_versions
    end

    def enforce_available_versions=(enforce_available_versions)
      @@enforce_available_versions = enforce_available_versions
    end      
    
    
  end
end
