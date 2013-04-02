require 'rubygems'
require 'ap' #awesome_print gem
require 'base64'
require 'hmac-sha2' #ruby-hmac gem
require 'rest_client' #rest-client gem

def build_authenticated_uri_query_string(signature, timestamp)
  "?x_a=#{$app_id}&x_b=#{$user_id}&x_c=#{get_base64_hash_string($app_key, signature)}&x_d=#{get_base64_hash_string($user_key, signature)}&x_t=#{timestamp}"
end

def create_authenticated_uri(path, httpmethod)
  query_string = get_query_string(path, httpmethod)
  "http://#{$hostname}#{path}#{query_string}"
end

def format_signature(path, httpmethod, timestamp)
  "#{httpmethod.upcase}&#{path.downcase}&#{timestamp}"
end

def get_base64_hash_string(key, signature)
  sha256_string = HMAC::SHA256.hexdigest(signature, key)
  sha256_string2 = HMAC::SHA256.hexdigest(key, signature)
  ap "sig first:  #{sha256_string}"
  ap "key first:  #{sha256_string2}"
  urlsafe_base64_string = Base64.urlsafe_encode64(sha256_string2).gsub('=', '')
end

def get_query_string(path, httpmethod)
  timestamp = Time.now.to_i + 3600
  signature = format_signature(path, httpmethod, timestamp)
  query_string = build_authenticated_uri_query_string(signature, timestamp)
end


# devsandbox.wiu.edu.desire2learnvalence.com
$app_id = "G9nUpvbZQyiPrk3um2YAkQ"
$app_key = "ybZu7fm_JKJTFwKEHfoZ7Q"

# admin:mencel6377e943
$user_id ="sNdpIGdXMBbjpNtXGSBXVO"
$user_key = "vnRxMIDYeGbd0E9-vNeN42"

$hostname = "devsandbox.wiu.edu.desire2learnvalence.com"
path = "/d2l/api/lp/1.0/users/whoami"
httpmethod = "GET"

the_uri = create_authenticated_uri(path, httpmethod)

puts "THE_URI:  #{the_uri}"

RestClient.get(the_uri){ |response, request, result, &block|
  case response.code
  when 200
    p "It worked !"
    ap response
  when 423
    raise SomeCustomExceptionIfYouWant
  else
    response.return!(request, result, &block)
  end
}

exit





ap "KEY:  #{app_key}"

# 1) Take the key used to create the signature and produce a set of key-bytes by ASCII-encoding the key.
app_key_asc = app_key.encode("ASCII")
user_key_asc = user_key.encode("ASCII")
ap "ASCII:  #{app_key_asc}"

# 2) Take the base-string for the signature and produce a set of base-string-bytes by UTF8-encoding the base-string.
app_key_utf8 = app_key_asc.encode("UTF-8")
user_key_utf8 = user_key_asc.encode("UTF-8")
ap "UTF8:  #{app_key_utf8}"

# 3) Produce the HMAC-SHA256 signature hash by using the key-bytes and base-string-bytes as input parameters.
signature = "GET&/d2l/api/lp/1.0/users/whoami&#{Time.now.to_i+3600}"

app_key_sha256 = HMAC::SHA256.hexdigest(signature, app_key_utf8)
user_key_sha256 = HMAC::SHA256.hexdigest(signature, user_key_utf8)
ap "SHA256:  #{app_key_sha256}"

# 4) Take the signature hash and produce a set of signature-bytes by base64url encoding the hash (see RFC 4648; no ‘=’ padding used, ‘+’ and ‘/’ replaced with ‘-‘ and ‘_’ respectively).
app_key_base64 = Base64.urlsafe_encode64(app_key_sha256).gsub('=', '')
user_key_base64 = Base64.urlsafe_encode64(user_key_sha256).gsub('=', '')
ap "BASE64:  #{app_key_base64.chomp}"


# 5) Pass these generated signature-bytes in all the query parameters where you’re expected to provide a signature.
unix_timestamp = Time.now.to_i
#api_sample_url = "http://devsandbox.wiu.edu.desire2learnvalence.com/d2l/auth/api/token?x_a=#{app_id}&x_b=#{app_key_base64}&x_target=myrubyprog://something"
api_sample_url = "http://devsandbox.wiu.edu.desire2learnvalence.com/d2l/api/lp/1.0/users/whoami?x_a=#{app_id}&x_b=#{user_id}&x_c=#{app_key_base64}&x_d=#{user_key_base64}&x_t=#{unix_timestamp}"
ap api_sample_url

RestClient.get(api_sample_url){ |response, request, result, &block|
  case response.code
  when 200
    p "It worked !"
    ap response
  when 423
    raise SomeCustomExceptionIfYouWant
  else
    response.return!(request, result, &block)
  end
}

ap response

exit



API_TOKEN_PATH = "/d2l/auth/api/token"
URL = "https://westernonline-beta.wiu.edu"

USER_ID = "Badm7gxucDxEbLzE0YO4e3"

USER_KEY = "xUIxUIiemgANTr2n-E3zz0"

#https://westernonline-beta.wiu.edu/d2l/auth/api/token?x+target=http://www.wiu.edu&x_a=G9nUpvbZQyiPrk3um2YAkQ&x_b=ybZu7fm_JKJTFwKEHfoZ7Q



response = RestClient.get "https://westernonline-beta.wiu.edu/d2l/auth/api/lp/1.0/users/whoami?x_a=#{APP_ID}&x_b=#{USER_ID}&"

puts response