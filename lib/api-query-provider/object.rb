module ApiQueryProvider
  class Object
    def self.data_selector
      @data_selector || Proc.new { |e| e }
    end
    
    def self.data_selector= (value)
      @data_selector = value
    end
    
    def self.autogenerate
      if @autogenerate.nil?
        false
      else
        @autogenerate
      end
    end
    
    def self.autogenerate= (value)
      @autogenerate = value
    end
    
    def self.field(field, opt = {}, &block)
      if opt.key? :aliases
        @alias[opt[:aliases]] = field.to_sym
      end
      
      if opt.key? :class
        # TODO: automatic class instantiation
      end
      
      if block_given?
        @fields[field.to_sym] = block.to_lambda
      end
    end
    
    def self.custom_field(field, &block)
      @custom_fields ||= {}
      
      @custom_fields[field.to_sym] = block.to_proc
    end
    
    def self.custom_fields
      @custom_fields || {}
    end
    
    def self.alias(key)
      key = key.to_sym
      
      if @alias.key? key
        @alias[key]
      end
      
      if @forbidden.key? key
        @forbidden[key]
      end
    end
    
    def self.shadow(key)
      key.to_sym == :class ? "class_".to_sym : key
    end
    
    attr_reader :provided_symbols
    
    def initialize(data)
      @provided_symbols = []
    
      data.each do |key, value|
        @provided_symbols << key.to_sym
             
        key = self.class.shadow key
      
        if !self.respond_to? key.to_sym
          if self.class.autogenerate
            self.class.class_eval do
              attr_accessor key.to_sym
            end
          else
            raise "field not found: #{key}. Either enable auto generation or add attr_accessor :#{key}"
          end
        end

        if self.class.custom_fields.include? key.to_sym
          value = self.class.custom_fields[key.to_sym].call(value)
        end
        
        self.send("#{key}=".to_sym, value)
      end
    end   
  end
end