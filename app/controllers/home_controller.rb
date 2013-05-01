require 'openssl'

class HomeController < ApplicationController

  def index
    @city_data = decrypt_city_data(params[:city_data], params[:city_data_iv])
    if @city_data.present?
      @city_auth_data = authentication_data(@city_data["oauth_token"])
    end
  end

  private

  def decrypt_city_data(city_data, city_data_iv)
    if city_data.present?
      string_to_decrypt = Base64.urlsafe_decode64(city_data)
      iv = Base64.urlsafe_decode64(city_data_iv)
      json_data = city_decrypt(string_to_decrypt, THE_CITY_APP_SECRET.first(32), iv)
      return ActiveSupport::JSON.decode(json_data)
    else
      return {}
    end
  end

  def city_decrypt(encrypted_data, key, iv, cipher_type = "AES-256-CBC")
    aes = OpenSSL::Cipher::Cipher.new(cipher_type)
    aes.decrypt
    aes.key = key
    aes.iv = iv if iv != nil
    aes.update(encrypted_data) + aes.final
  end

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
