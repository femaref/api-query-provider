module ApiQueryProvider
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
     
    def initialize(data)
      if self == ApiQueryProvider::Base
        throw "this class should never be instanciated directly"
      end
    
      data.each do |key, value|
        self.send("#{key}=".to_sym, value)
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