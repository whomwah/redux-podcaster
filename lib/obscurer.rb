require "base64"

module Obscurer

  def self.obscure(str)
    str = str.downcase.strip
    Base64.encode64([str,SALT].join('+')).strip.gsub(/=/,'')
  end

  def self.unobscure(str)
    str = str.downcase.strip
    Base64.decode64(str).split('+').first 
  end

end
