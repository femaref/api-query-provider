module ApiQueryProvider
  class Base < Provider
    def initialize(data)
      if self == ApiQueryProvider::Base
        throw "this class should never be instanciated directly"
      end
    
      data.each do |key, value|
        self.send("#{key}=".to_sym, value)
      end
    end
  end
end