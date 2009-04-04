require "base64"

module Obscurer

  def self.obscure(str)
    Base64.encode64([str,SALT].join('+')).strip.gsub(/=/,'')
  end

  def self.unobscure(str)
    Base64.decode64(str).split('+').first 
  end

end
