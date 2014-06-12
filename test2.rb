require 'rubygems'
require 'ap' # awesome_print gem
require 'base64'
require 'hmac-sha2' # ruby-hmac gem
require 'rest_client' # rest-client gem

#vars
$hostname = 'wiutest.desire2learn.com'
$user_id = 'sJiaLZAl41bHfa_fnyfyAp'
$user_key = '3MznLMWrEtGU0XJddnj15W'
$app_id = 'ysuBVIqmRDaJpnVEOb8Ylg'
$app_key = 't3Rro3P91i_U1let5vd8Wg'
path = '/d2l/api/lp/1.0/users/whoami'
httpmethod = 'GET'
$timestamp = Time.now.to_i + 3600 #current hour plus one hour

def build_authenticated_uri_query_string(signature, timestamp)
  "?x_a=#{$app_id}&x_b=#{$user_id}&x_c=#{get_base64_hash_string($app_key, signature)}&x_d=#{get_base64_hash_string($user_key, signature)}&x_t=#{timestamp}"
end

def authenticate_uri(path, httpmethod)
  query_string = get_query_string(path, httpmethod)
  ap "https://#{$hostname}#{$path}#{query_string}"
end

def format_signature(path, httpmethod, timestamp)
  "#{httpmethod.upcase}&#{path.downcase}&#{$timestamp}"
end

def get_base64_hash_string(key, signature)
  sha256_string = HMAC::SHA256.hexdigest(signature, key)
  sha256_string2 = HMAC::SHA256.hexdigest(key, signature)
  ap "sig first:  #{sha256_string}"
  ap "key first:  #{sha256_string2}"
  urlsafe_base64_string = Base64.urlsafe_encode64(sha256_string2).gsub('=', '')
end

def get_query_string(path, httpmethod)
  signature = format_signature(path, httpmethod, $timestamp)
  query_string = build_authenticated_uri_query_string(signature, $timestamp)
end

the_uri = authenticate_uri(path, httpmethod)

puts "THE_URI:  #{the_uri}"

RestClient.get(the_uri){ |response, request, result, &block|
  case response.code
  when 200
    p 'It worked !'
    ap response
  when 423
    fail SomeCustomExceptionIfYouWant
  when 403
    ap response
  else
    response.return!(request, result, &block)
  end
}

exit