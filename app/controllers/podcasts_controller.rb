class PodcastsController < ApplicationController
  def index
    return redirect_to root_url if params[:guid].blank?
    redirect_to(:action => 'show')
  end

  def show
    key = podcast_path(:guid => params[:guid])
    pid = Obscurer.unobscure(params[:guid])
    @brand = handle_fragment(key,pid)

    respond_to do |format|
      format.xml
    end
  rescue URI::InvalidURIError, OpenURI::HTTPError, SocketError, Errno::ENETUNREACH
    custom_404 
  end

  def url
    return render(:status => 404, :template => 'podcasts/show') if params[:pid].blank?
    @guid = Obscurer.obscure(params[:pid])
    key = podcast_path(:guid => @guid)
    @brand = handle_fragment(key,params[:pid])
  rescue URI::InvalidURIError, OpenURI::HTTPError, SocketError, Errno::ENETUNREACH
    custom_404
  end

  private

  def handle_fragment(key,pid)
    expire_fragment(key) unless 
      brand = read_fragment(key, :expires_in => 6.hours) || write_fragment(key, Redux.data(pid))
    return brand
  end

  def custom_404
    render(:status => 404, :template => 'podcasts/show')
  end
end
