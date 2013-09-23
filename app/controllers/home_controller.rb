class HomeController < ApplicationController

  def index
    @raw_city_data = params[:city_data]
    @raw_city_data_iv = params[:city_data_iv]
    @decrypted_city_data = Cityplugin::decrypt_city_data(@raw_city_data, @raw_city_data_iv, THE_CITY_APP_SECRET.first(32))

    @city_data = ActiveSupport::JSON.decode(@decrypted_city_data)
    if @city_data.present?
      @city_auth_data = authentication_data(@city_data["oauth_token"])
    end
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

end
