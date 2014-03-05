class HomeController < ApplicationController

  before_filter :set_city_data

  def index
    if params[:cookies].present? and params[:cookies] == 'true'
      browser = Browser.new(:ua => request.env['HTTP_USER_AGENT'], :accept_language => "en-us")
      if browser.safari? and cookies[:safari_cookie].blank?
        render :template => "home/safari_link"
        return
      else
        cookies[:user_id] = @city_data['user_id']
      end
    end
  end

  def safari_cookie
    cookies.permanent[:safari_cookie] = "true"
    cookies[:city_data] = params[:city_data]
    cookies[:city_data_iv] = params[:city_data_iv]
  end


  private

  def authentication_data(auth_token)
    response = Typhoeus::Request.send(:get, THE_CITY_AUTH_URL, :params => {:access_token => auth_token})
    response_body = {}
    if response.success?
      response_body = (JSON.parse(response.body) rescue {})
    elsif response.timed_out?
      puts "got a time out"
    elsif response.code == 0
      puts response.curl_error_message
    else
      puts "HTTP request failed: " + response.code.to_s
    end
    return response_body
  end

  def set_city_data

    if params.key?(:city_data)
      @raw_city_data = params[:city_data]
      @raw_city_data_iv = params[:city_data_iv]
    elsif cookies[:city_data].present?
      @raw_city_data = cookies[:city_data]
      @raw_city_data_iv = cookies[:city_data_iv]
    else
      @raw_city_data = nil
      @raw_city_data_iv = nil
    end

    if @raw_city_data.present? and @raw_city_data_iv.present?
      @decrypted_city_data = Thecity::Plugin::decrypt_city_data(@raw_city_data, @raw_city_data_iv, THE_CITY_APP_SECRET.first(32))

      @city_data = ActiveSupport::JSON.decode(@decrypted_city_data)
      if @city_data.present?
        @city_auth_data = authentication_data(@city_data["oauth_token"])
      end
    end

  end

end
