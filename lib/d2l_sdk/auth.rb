require 'rubygems' # useful
require 'awesome_print' # useful for debugging
require 'base64' # NEEDED
require 'json' # NEEDED
require 'rest-client' # NEEDED
require 'openssl' # NEEDED
require 'open-uri' # NEEDED
require 'colorize' # useful
require_relative 'config'

# Global variables initialized through require_relative 'D2L_Config'

# requests input from the user, cuts off any new line and downcases it.
#
# returns: String::downcased_user_input
def prompt(*args)
    print(*args)
    gets.chomp.downcase
    # returns: String::downcased_user_input
end

# Creates an authenticated uniform resource identifier that works with Valence
# by calling +URI.parse+ using the path downcased, then creating a query string
# by calling +_get_string+ with the parsed_url and the http_method. These are
# used as the Variables and then returned as the finished uri.
#
# Input that is required is:
#  * path: The path to the resource you are trying to accessing
#  * http_method: The method utilized to access/modify the resource
#
# returns: String::uri
def create_authenticated_uri(path, http_method)
    parsed_url = URI.parse(path.downcase)
    uri_scheme = 'https'
    query_string = _get_string(parsed_url.path, http_method)
    uri = uri_scheme + '://' + $hostname + parsed_url.path + query_string
    uri << '&' + parsed_url.query if parsed_url.query
    uri
    # returns: String::uri
end

# Builds an authenticated uniform resource identifier query string that
# works properly with the Valence API.
#
# Required Variables:
# * app_id, user_id, app_key, user_key
#
# returns: String::'authenticated_uri'
def build_authenticated_uri_query_string(signature, timestamp)
    "?x_a=#{$app_id}"\
    "&x_b=#{$user_id}"\
    "&x_c=#{get_base64_hash_string($app_key, signature)}"\
    "&x_d=#{get_base64_hash_string($user_key, signature)}"\
    "&x_t=#{timestamp}"
    # returns: String::'authenticated_uri'
end

# uses the path, http_method, and timestamp arguments to create a properly
# formatted signature. Then, this is returned.
#
# returns: String::signature
def format_signature(path, http_method, timestamp)
    http_method.upcase + '&' + path.encode('UTF-8') + '&' + timestamp.to_s
    # returns: String::signature
end

# uses the key and signature as arguments to create a hash using
# +OpenSSL::HMAC.digest+ with an additional argument denoting the hashing
# algorithm as 'sha256'. The hash is then encoded properly and all "="
# are deleted to officially create a base64 hash string.
#
# returns: String::base64_hash_string
def get_base64_hash_string(key, signature)
    hash = OpenSSL::HMAC.digest('sha256', key, signature)
    Base64.urlsafe_encode64(hash).delete('=')
    # returns: String::base64_hash_string
end

# Used as a helper method for create_authenticated_uri in order to properly
# create a query string that will (hopefully) work with the Valence API.
# the arguments path and http_method are used as arguments with the current time
# for +format_signature+ and +build_authenticated_uri_query_string+.
#
# returns: String::query_string
def _get_string(path, http_method)
    timestamp = Time.now.to_i
    signature = format_signature(path, http_method, timestamp)
    unless path.include? "/auth/api/token"
      build_authenticated_uri_query_string(signature, timestamp)
    else
      # build authenticated query string not using typical schema
      build_authenticated_token_uri_query_string(signature, timestamp)
    end
    # returns: String::query_string
end
