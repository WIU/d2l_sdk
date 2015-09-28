
require 'rubygems'
require 'ap' # awesome_print gem
require 'base64'
# require 'hmac-sha2' # ruby-hmac gem
require 'json'
require 'restclient' # rest-client gem
require 'openssl'
require 'open-uri'
require 'launchy'


# vars
$hostname = 'wiutest.desire2learn.com'

# User ID = api-user
# User PW = see keepass

$user_id = 'rV5wdZwBbnT4prgaLlqx05'
$user_key = 'xVee4KJhixBCQphf-3Wuf9'
$app_id = 'ysuBVIqmRDaJpnVEOb8Ylg'
$app_key = 't3Rro3P91i_U1let5vd8Wg'
path = '/d2l/api/lp/1.4/users/'
path = '/d2l/api/lp/1.4/enrollments/users/47892/orgUnits/'
#path = '/d2l/api/lp/1.4/users/whoami'
#path = '/d2l/api/versions/'
http_method = 'GET'
$timestamp = Time.now.to_i # current hour
#$timestamp = 1406652368

def create_authenticated_uri(path, http_method)
  parsed_url = URI.parse(path.downcase)
  uri_scheme = 'https'
  query_string = get_query_string(parsed_url.path, http_method)
  uri = uri_scheme + '://' + $hostname + parsed_url.path + query_string
  uri << '&' + parsed_url.query if parsed_url.query
  return uri
end

def build_authenticated_uri_query_string(signature, timestamp)
  "?x_a=#{$app_id}"\
  "&x_b=#{$user_id}"\
  "&x_c=#{get_base64_hash_string($app_key, signature)}"\
  "&x_d=#{get_base64_hash_string($user_key, signature)}"\
  "&x_t=#{timestamp}"
end

def authenticate_uri(path, http_method)
  get_query_string(path, http_method)
end

def format_signature(path, http_method, timestamp)
  http_method.upcase + '&' + path.encode('UTF-8') + '&' + timestamp.to_s
end

def get_base64_hash_string(key, signature)
  hash = OpenSSL::HMAC.digest('sha256', key, signature)
  Base64.urlsafe_encode64(hash).gsub('=', '')
end

def get_query_string(path, http_method)
  signature = format_signature(path, http_method, $timestamp)
  build_authenticated_uri_query_string(signature, $timestamp)
end

# # Take the key used to create the signature and produce a set of key-bytes by
# # UTF8-encoding the key.
# key_bytes = $app_key.encode('UTF-8')
# puts key_bytes
#
# # Take the base-string for the signature and produce a set of base-string-bytes
# # by UTF8-encoding the base-string.
# base_str_bytes = "https://#{$hostname}/d2l/api/versions".encode('UTF-8')
# puts base_str_bytes
#
# # Produce the HMAC-SHA256 signature hash by using the key-bytes and
# # base-string-bytes as input parameters.
# hash = OpenSSL::HMAC.digest('sha256', key_bytes, base_str_bytes)
# sig_hash =  Base64.encode64(hash)
# ap sig_hash
#
# # Take the signature hash and produce a set of signature-bytes by base64url
# # encoding the hash (see RFC 4648; no ‘=’ padding used, ‘+’ and ‘/’ replaced
# # with ‘-‘ and ‘_’ respectively).
# sig_bytes = Base64URL.encode(hash)
# ap sig_bytes
#
# # Pass these generated signature-bytes in all the query parameters where you are
# # expected to provide a signature.
# x_target = "https://#{$hostname}/d2l/api/versions"
# auth_uri = "https://#{$hostname}/d2l/auth/api/token?x_a=#{$app_id}&x_b=#{sig_bytes}&x_target=#{URI.escape(x_target)}"
# puts auth_uri
#
# unix_ts = $timestamp
# # the_uri = "/d2l/api/lp/1.2/users/whoami"
# the_uri = '/d2l/api/lp/1.2/enrollments/users/47892/orgUnits/'
# app_str = "GET&#{the_uri}&#{unix_ts}"
# # app_str = "GET&/d2l/api/lp/1.2/enrollments/users/47892/orgUnits/&1406597032"
# hash = OpenSSL::HMAC.digest('sha256', key_bytes, app_str)
# app_hash =  Base64.urlsafe_encode64(hash).gsub('=', '')
#
# hash = OpenSSL::HMAC.digest('sha256', $user_key.encode('UTF-8'), app_str)
# user_hash = Base64.urlsafe_encode64(hash).gsub('=', '')
# # user_bytes = Base64URL.encode(user_hash).gsub('=', '')
# ap user_hash
#

hash = OpenSSL::HMAC.digest('sha256', "#{$user_id}&#{$user_key}", $app_key)
x_c = Base64.urlsafe_encode64(hash).gsub('=', '')
puts x_c
# version_uri = "https://#{$hostname}#{the_uri}?x_a=#{$app_id}&x_b=#{$user_id}&x_c=#{app_hash}&x_d=#{user_hash}&x_t=#{unix_ts}"
# puts version_uri

test_uri = create_authenticated_uri(path, http_method)
puts test_uri
RestClient.get(test_uri){ |response, request, result, &block|
  case response.code
  when 200
    p 'It worked !'
    p JSON.parse(response).class
    p JSON.parse(response)
    ap JSON.parse(response)
  when 423
    fail SomeCustomExceptionIfYouWant
  when 403
    # Launchy.open(the_uri)
    ap response
  else
    response.return!(request, result, &block)
  end

  # ap response.return!(request, result, &block)
}
