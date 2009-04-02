class Service
  attr_accessor :title, :key, :type

  def initialize(s)
    return nil unless
    @title = s  
    @key = SERVICES[s][:key]
    @type = SERVICES[s][:type]
  end
end
