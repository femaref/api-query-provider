module ApiQueryProvider
  # Provides method chaining support
  # replaces parameters in the api_path
  # named parameters will be replaced by the assosicated value from where calls
  # if a :where symbol is present in the string, any further values provided by where will be
  # concatted to a key1=value,key2=value string and replaced there
  # a value provided by limit will be replaced in to the :limit symbol
  # if you can request additional fields or restrict the fields provided, place a :select symbol in the string
  class Provider   
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
    
    def select(*fields)
      @select_fields |= fields.flatten
      
      return self
    end
    
    def replace_path
      replaced_path = klass.api_path
      
      used_keys = []
      
      @where_constraints.each do |key, value|
        if replaced_path.gsub! /:#{key}/, value.to_s
          used_keys << key
        end
      end
      
      @where_constraints.reject! { |key, value| used_keys.include? key }
      
      replaced_path.gsub! /:where/, @where_constraints.to_a.map { |e| e.join("=") }.join("&")
      replaced_path.gsub! /:select/, @select_fields.join(",")
      replaced_path.gsub! /:limit/, @count_constraint.to_s
      
      if replaced_path.include?(":")
        throw "you didn't replace all fields in the api_path"
      end
      
      replaced_path
    end
    
    def response
      begin
        uri = URI.join(klass.api_url, self.replace_path)
      rescue
        throw "invalid uri"
      end
      
      HTTParty.get(uri.to_s)
    end
    
    def execute
      local_response = self.response
      
      [klass.data_selector.call(JSON.parse(local_response.body))].flatten.map do |elem|
        klass.new elem
      end
    end
    
    def self.interface
      ApiQueryProvider::Provider.new(self)
    end
  end
end