require_relative 'auth'

########################
# QUERIES/RESPONSE:#####
########################
def _get(path)
    uri_string = create_authenticated_uri(path, 'GET')
    RestClient.get(uri_string) do |response, _request, _result|
        case response.code
        when 200
            # ap JSON.parse(response) # Here is the JSON fmt'd response printed
            JSON.parse(response)
        else
            display_reponse_code(response.code) # display informaiton on the err code
            # response.return!(request, result, &block)
            # response.return!
            # puts '[!] Get query failed, see above response code'.red
        end
    end
end

def _post(path, payload)
    auth_uri = create_authenticated_uri(path, 'POST')
    RestClient.post(auth_uri, payload.to_json, content_type: :json)
end

def _put(path, payload)
    auth_uri = create_authenticated_uri(path, 'PUT')
    # Perform the put action, updating the data; Provide feedback to client.
    RestClient.put(auth_uri, payload.to_json, content_type: :json)
end

def _delete(path)
    auth_uri = create_authenticated_uri(path, 'DELETE')
    RestClient.delete(auth_uri, content_type: :json)
end

def display_reponse_code(code)
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
        puts "[!] 423"
    when 500
        puts '[!] 500: General Service Error\n'\
          'Empty response body. The service has encountered an unexpected'\
            'state and cannot continue to handle your action request.'
    when 504
        puts '[!] 504: Service Error'
    end
end
