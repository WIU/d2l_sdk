require_relative 'auth'

########################
# QUERIES/RESPONSE:#####
########################

# performs a get request on a particular path of the host.
# To do this, a uniform resource identifier string is created using the path and
# specifying that this is a get request. Then, the RestClient get method is
# used to retrieve the data and parse it as a JSON. Then, the parsed response is
# returned. Otherwise, nothing is returned and the response code is printed
#
# returns: JSON parsed response.
def _get(path)
    uri_string = create_authenticated_uri(path, 'GET')
    RestClient.get(uri_string) do |response, _request, _result|
        case response.code
        when 200
            # ap JSON.parse(response) # Here is the JSON fmt'd response printed
            JSON.parse(response)
        else
            display_response_code(response.code)
            puts response
        end
    end
end

# performs a post request using the path and the payload arguments. First, an
# authenticated uri is created to reference a particular resource. Then, the
# post method is executed using the payload and specifying that it is formatted
# as JSON.
def _post(path, payload)
    auth_uri = create_authenticated_uri(path, 'POST')
    RestClient.post(auth_uri, payload.to_json, content_type: :json)
end

# performs a put request using the path and the payload arguments. After first
# creating an authenticated uri, the put request is performed using the
# authenticated uri, the payload argument, and specifying that the payload is
# formatted in JSON.
def _put(path, payload)
    auth_uri = create_authenticated_uri(path, 'PUT')
    # Perform the put action, updating the data; Provide feedback to client.
    RestClient.put(auth_uri, payload.to_json, content_type: :json)
end

# Performs a delete request by creating an authenticated uri and using the
# RestClient delete method and specifying the content_type as being JSON.
def _delete(path)
    auth_uri = create_authenticated_uri(path, 'DELETE')
    RestClient.delete(auth_uri, content_type: :json)
end

# based upon the specific code that is returned from the http method, this
# displays the response, in the case that it is an error within the request
# or the server. This is simply informative and assists in describing the
# lacking response information from the valence api. In the case of a Bad
# Request, it is likely that it cannot be further specified without looking
# back at the d2l_api documentation or looking at the documentation on
# the docs.valence.desire2learn.com website.
def display_response_code(code)
    case code
    when 400
        puts '[!] 400: Bad Request'
    when 401
        puts '[!] 401: Unauthorized'

    when 403
        print '[!] Error Code Forbidden 403: accessing the page or resource '\
              'you were trying to reach is absolutely forbidden for some reason.'
    when 404
        puts '[!] 404: Not Found'
    when 405
        puts '[!] 405: Method Not Allowed'
    when 406
        puts 'Unacceptable Type'\
    	    'Unable to provide content type matching the client\'s Accept header.'
    when 412
        puts '[!] 412: Precondition failed\n'\
          'Unsupported or invalid parameters, or missing required parameters.'
    when 415
        puts '[!] 415: Unsupported Media Type'\
          'A PUT or POST payload cannot be accepted.'
    when 423
        puts '[!] 423'
    when 500
        puts '[!] 500: General Service Error\n'\
          'Empty response body. The service has encountered an unexpected'\
            'state and cannot continue to handle your action request.'
    when 504
        puts '[!] 504: Service Error'
    end
end

#################
###Versions######
#################
def get_all_products_supported_versions
  path = "/d2l/api/versions/"
  _get(path)
  # returns array of product codes in a JSON block
end

# Retrieve the collection of versions supported by a specific product component
def get_product_supported_versions(product_code)
  path = "/d2l/api/#{product_code}/versions/"
  _get(path)
end

def get_latest_product_version(product_code)
  get_product_supported_versions(product_code)["SupportedVersions"][-1]
end

# init products to newest versions.
$le_ver = get_latest_product_version('le')
$lp_ver = get_latest_product_version('lp')
$ep_ver = get_latest_product_version('ep')
#lti, rp, LR, ext,

# retrieve all supported versions for all product components
def get_versions
  path = "/d2l/api/versions/"
  _get(path)
  # returns: SupportedVersion JSON block
end

#determine if a specific product component supports a particular API version
def check_if_product_supports_api_version(product_code, version)
  path = "/d2l/api/#{product_code}/versions/#{version}"
  _get(path)
end

def check_supported_version_request_validity(supported_version_request)
    schema = {
      'type' => 'array',
      'items' =>
        {
            'type' => "object",
            "properties" =>
            {
              "Productcode" => {'type'=>"string"},
              "Version" => {'type'=>"string"}
            }
        }
    }
    JSON::Validator.validate!(schema, supported_version_request, validate_schema: true)
end

# determine versions supported by the back-end Brightspace API
# requires: JSON SupportedVersionRequest data block
def check_product_versions(supported_version_request)
  payload =
  [
    {
      "ProductCode" => "9.9",
      "Version" => "9.9"
    }
  ].merge!(supported_version_request)
  # requires: JSON SupportedVersionRequest data block
  check_supported_version_request_validity(payload)
  path = "/d2l/api/versions/check"
  _post(path, payload)
  # returns: BulkSupportedVersionResponse JSON block
end
