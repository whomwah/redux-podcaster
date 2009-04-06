class HomeController < ApplicationController
  before_filter :authenticate

  protected

  def authenticate
    authenticate_or_request_with_http_basic(realm = 'Enter your BBC Redux login details') do |username,password| 
      #return true if request.host =~ /\.local$/
      if Redux.valid_user?(username,password)
        true 
      else
        return render(:status => 401, :template => 'home/badlogin')
      end
    end
  rescue URI::InvalidURIError, OpenURI::HTTPError, SocketError, Errno::ENETUNREACH
    render(:status => 401, :template => 'home/badlogin')
  end
end
