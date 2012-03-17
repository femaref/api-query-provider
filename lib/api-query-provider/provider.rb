module ApiQueryProvider
  class Provider
    
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
  
      
    attr_reader :where_constraints
    attr_reader :count_constraint
    attr_reader :select_fields
    attr_reader :klass
    
    def initialize (base)    
      api_url = base.api_url
      api_path = base.api_path
      if base.is_a? Class
        @where_constraints = {}
        @select_fields = []
        @count_constraint = 0
        @klass = base
      else
        @where_constraints = base.where_constraints
        @select_fields = base.select_fields
        @count_constraint = base.count_constraint
      end

    end
    
    def where(opt = {})
      @where_constraints.merge! opt
      
      return self
    end
    
    def limit(count)
      @count_constraint = count
      
      return self
    end
    
    def self.where(opt = {})
      interface.where(opt)
    end
    
    def self.limit(count)
      interface.limit(count)
    end
    
    def replace_path
      replaced_path = klass.api_path
      
      @where_constraints.each do |key, value|
        replaced_path.gsub! /:#{key}/, value.to_s
      end
      
      replaced_path
    end
    
    def execute
      begin
        uri = URI.join(klass.api_url, self.replace_path)
      rescue
        throw "invalid uri"
      end
      
      response = HTTParty.get(uri.to_s)
      
      [klass.data_selector.call(JSON.parse(response.body))].flatten.map do |elem|
        klass.send(:new, elem)
      end
    end
    
    def self.interface
      ApiQueryProvider::Provider.new(self)
    end
  end
end