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
  class Base
  
    def self.api_url
      @api_url
    end
    
    def self.api_url= (value)
      @api_url = value
    end
    
    def self.api_path
      @api_path
    end
    
    def self.api_path= (value)
      @api_path = value
    end
    
    def self.required_values
      @api_path.scan(/:(\w+)/).flatten.map { |e| e.to_sym } - ApiQueryProvider::Provider.system_symbols
    end
    
    def self.data_selector
      @data_selector || Proc.new { |e| e }
    end
    
    def self.data_selector= (value)
      @data_selector = value
    end
    
    def self.autogenerate
      @autogenerate || false
    end
    
    def self.autogenerate= (value)
      @autogenerate = value
    end
    
    def self.custom(field, &block)
      @customs ||= []
      
      @customs[field.to_sym] = block.to_proc
    end
    
    def self.customs
      @customs || []
    end
    
    def self.shadow(key)
      key.to_sym == :class ? "class_".to_sym : key
    end
    
    attr_reader :provided_symbols
    
     
    # basic parsing constructor
    # takes the json data and tries to assign it to +attr_accessor+ methods
    # make sure to define them for any field present in the response
    def initialize(data)
      if self == ApiQueryProvider::Base
        throw "this class should never be instanciated directly"
      end
      
      @provided_symbols = []
    
      data.each do |key, value|
        @provided_symbols << key
      
        key = self.class.shadow key
      
        if !self.respond_to? key.to_sym
          if self.class.autogenerate
            self.class.class_eval do
              attr_accessor key.to_sym
            end
          else
            throw "field not found: #{key}. Either enable auto generation or add attr_accessor :#{key}"
          end
        end

        if self.class.customs.include? key.to_sym
          value = self.class.customs[key.to_sym].call(value)
        end
        
        self.send("#{key}=".to_sym, value)
      end
    end
    
    def extend
      if !(self.class.required_symbols - @provided_values).empty?
        throw "not all needed values are present"
      end
      
      request = self.class
      
      self.class.required_symbols.each do |sym|
        request = request.where(sym => self.send(self.class.shadow(sym).to_sym))
      end
      
      response = request.execute
      
      if response.count != 1
        throw "the request did not return exactly one element"
      end
      
      response = response.first
      
      response.provided_symbols do |sym|
        self.send("#{self.class.shadow(sym)}=".to_sym, response.send("#{self.class.shadow(sym)}"))
      end    
      
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