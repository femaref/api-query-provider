module ApiQueryProvider
  # This class serves as a base class for any API Requests, it has several settings:
  # +api_url+: sets the base url requests are made to_sym
  # +api_path+: sets the path specific to this class, can contain replaceable elements
  # +data_selector+: if the data is wrapped in an object, you can define a +Proc+ taking
  # the parsed response as Hash and returning a portion of that Hash for further parsing
  # the keys are +String+s.
  # Be aware that if the data contains any fields named like a ruby internal method or field,
  # it will be shadowed if you define it explicitly, it autogeneration is enabled, the name will
  # have a underscore appended.
  class Base < Object
  
    def self.api_for (opt = {})
      @settings = opt
      
      if !@settings.has_key? :api_url
        raise "you need to define a api_url in #{self.class.name}"
      end
      
      if !@settings.has_key? :api_path
        raise "you need to define a api_path in #{self.class.name}"
      end
    end
    
    def self.api_url
      @settings[:api_url]
    end
    
    def self.api_path
      @settings[:api_path]
    end
      
    def self.required_symbols
      @settings[:api_path].scan(/:(\w+)/).flatten.map { |e| e.to_sym } - ApiQueryProvider::Provider.system_symbols
    end
    
    def initialize(data)
      if self.class == ApiQueryProvider::Base
        raise "this class should never be instanciated directly"
      end
      
      super data
    end
    
    def extend
      if !(self.class.required_symbols - provided_symbols).empty?
        raise "not all needed values are present"
      end
      
      request = self.class.where
      
      self.class.required_symbols.each do |sym|
        request = request.where(sym => self.send(self.class.shadow(sym).to_sym))
      end
      
      response = request.execute
      
      if response.count != 1
        raise "the request did not return exactly one element"
      end
      
      response.first 
    end
    
    def extend!
      local = self.extend
      
      local.provided_symbols.each do |symbol|
        shadow = self.class.shadow(symbol).to_sym
        self.send("#{shadow}=".to_sym, local.send("#{shadow}".to_sym))
      end
      
      @provided_symbols = local.provided_symbols
      
      self
    end
      
    def self.interface
      ApiQueryProvider::Provider.new(self)
    end
    
    def self.where(opt = {})
      interface.where(opt)
    end
    
    def self.limit(count)
      interface.limit(count)
    end
    
    def self.select(*fields)
      interface.select(fields)
    end
  end
end