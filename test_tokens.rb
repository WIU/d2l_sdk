require_relative "lib/d2l_sdk"
require 'oauth2'

ap get_token
#ap get_token.body
#response = get_token
#ap response.code
#ap response.headers
#login_url = "https://wiutest.desire2learn.com/d2l/lp/auth/login/login.d2l"
#RestClient.post(login_url, {"userName" => "api-user","password" => "t1w1u5d2l@p1", "Login" => "Login"}, content_type: 'application/x-www-form-urlencoded+json') { |response| cookies = response.cookies}
=begin
# Client vars
client_id = "119734ea-77af-4604-844b-abfdbf6d4116"
client_secret = "RzybPn_uye-uMJXzc8NEkEAu26MpWow7YwN8nR0z-xE"
site = 'https://wiutest.desire2learn.com'
token_url = "https://auth.brightspace.com/core/connect/token"
auth_url = "https://auth.brightspace.com/oauth2/auth"
scope = "data:aggregates:read"
client = OAuth2::Client.new(client_id, client_secret, :site => site, token_url: token_url, authorize_url: auth_url)
code_url = client.auth_code.authorize_url(redirect_uri: 'http://localhost:8080/oauth/callback', :scope => scope)
ap code_url
puts "input code"
code = gets.chomp
#code = "93K2e35fnwf9AmS0aMawSpOpXeGuyTuou3iWEsMCBME"
token = client.auth_code.get_token(code, :redirect_uri => 'http://localhost:8080/oauth/callback')
=end
#ap access_token
=begin

timestamp = Time.now.to_i
cookies = {}
RestClient.post("https://wiutest.desire2learn.com/d2l/lp/auth/login/login.d2l", {"userName" => "api-user","password" => "t1w1u5d2l@p1", "Login" => "Login"}, content_type: 'application/x-www-form-urlencoded+json') { |response| cookies = response.cookies}
#String::'authenticated_uri'
token_path = "https://wiutest.desire2learn.com/d2l/auth/api/token"
signature = format_signature(token_path, "GET", timestamp)
#client_id =  "119734ea-77af-4604-844b-abfdbf6d4116" #
app_id = "m_HPR2KE2y4FqZx0VWm04Q"
#client_key = "RzybPn_uye-uMJXzc8NEkEAu26MpWow7YwN8nR0z-xE" #
app_key = "iaOSf52DHLcP1ybk94cZHQ"
trusted_url = "https%3A%2F%2Fwiutest.desire2learn.com"
uri_string =  "?x_target=" + "#{trusted_url}"\
              "&x_a=#{app_id}"\
              "&x_b=#{get_base64_hash_string("#{app_key}", signature)}"
# require 'oauth2'
# client = OAuth2::Client.new("119734ea-77af-4604-844b-abfdbf6d4116","RzybPn_uye-uMJXzc8NEkEAu26MpWow7YwN8nR0z-xE", :site => 'https://wiutest.desire2learn.com', token_url: "https://auth.brightspace.com/core/connect/token", authorize_url: "https://auth.brightspace.com/oauth2/auth")
# code = client.auth_code.authorize_url(redirect_uri: "https://wiutest.desire2learn.com", :client_id => "119734ea-77af-4604-844b-abfdbf6d4116", :scope => "data:aggregates:read")
# token = client.password.get_token('api-user', 't1w1u5d2l@p1')
url = token_path + uri_string
puts url
RestClient::Request.execute(url: url, method: :get, cookies: {"d2lSecureSessionVal"=> cookies["d2lSecureSessionVal"], "d2lSessionVal" => cookies["d2lSessionVal"], "Login" => "true"}) do |response, request|
  ap request
  response
end

client = OAuth2::Client.new("119734ea-77af-4604-844b-abfdbf6d4116","RzybPn_uye-uMJXzc8NEkEAu26MpWow7YwN8nR0z-xE", :site => 'https://wiutest.desire2learn.com', token_url: "https://auth.brightspace.com/core/connect/token", authorize_url: "https://auth.brightspace.com/oauth2/auth")
code = client.auth_code.authorize_url(:client_id => "119734ea-77af-4604-844b-abfdbf6d4116", :scope => "data:aggregates:read")
puts code
##### NOT IMPLEMENTED or SUPPORTED
#token = client.implicit.get_token
#token = client.password.get_token("api-user","t1w1u5d2l@p1")
#token = client.client_credentials.get_token
#token = client.assertion.get_token

#####Confidential clients are not permitted to use the request body when authenticating
token = client.auth_code.get_token(code, :redirect_uri => "https://wiutest.desire2learn.com")


=end
