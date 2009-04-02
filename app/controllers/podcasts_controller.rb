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
  end

  def url
    return render(:status => 404, :template => 'podcasts/show') if params[:pid].blank?
    @guid = Obscurer.obscure(params[:pid])
    key = podcast_path(:guid => @guid)
    @brand = handle_fragment(key,params[:pid])
  end

  private

  def handle_fragment(key,pid)
    expire_fragment(key) unless 
      brand = read_fragment(key, :expires_in => 6.hours) || write_fragment(key, Redux.data(pid))
    return brand
  rescue URI::InvalidURIError, OpenURI::HTTPError, SocketError, Errno::ENETUNREACH
    return render(:status => 404, :template => 'podcasts/show')
  end
end
