class HomeController < ApplicationController
  before_filter :authenticate

  protected

  def authenticate
    authenticate_or_request_with_http_basic(realm = 'Enter your BBC Redux login details') do |username,password| 
      Redux.valid_user?(username,password)
    end
  rescue URI::InvalidURIError, OpenURI::HTTPError, SocketError, Errno::ENETUNREACH
    render(:status => 404, :template => 'podcasts/show')
  end
end
