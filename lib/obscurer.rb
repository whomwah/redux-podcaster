require "base64"

module Obscurer

  def self.obscure(str)
    Base64.encode64([str.strip,SALT].join('+')).strip.gsub(/=/,'')
  end

  def self.unobscure(str)
    Base64.decode64(str.strip).split('+').first 
  end

end
