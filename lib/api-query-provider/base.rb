module ApiQueryProvider
  # This class serves as a base class for any API Requests, it has several settings:
  # +api_url+: sets the base url requests are made to_sym
  # +api_path+: sets the path specific to this class, can contain replaceable elements
  # +data_selector+: if the data is wrapped in an object, you can define a +Proc+ taking
  # the parsed response as Hash and returning a portion of that Hash for further parsing
  # the keys are +String+s.
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
     
    # basic parsing constructor
    # takes the json data and tries to assign it to +attr_accessor+ methods
    # make sure to define them for any field present in the response
    def initialize(data)
      if self == ApiQueryProvider::Base
        throw "this class should never be instanciated directly"
      end
    
      data.each do |key, value|
        if self.respond_to?("#{key}=".to_sym)
          self.send("#{key}=".to_sym, value)
        elsif self.class.autogenerate
          self.class.class_eval do
            attr_accessor key.to_sym
          end
        else
          throw "field not found: #{key}. either enable auto generation or supply attr_accessors"
        end
        
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