module ApiQueryProvider
  class Base < Provider      
    def initialize(data)
      data.each do |key, value|
        self.send(key.to_sym, value)
      end
    end
  end
end