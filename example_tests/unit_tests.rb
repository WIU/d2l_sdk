require_relative 'd2l_api'

# Test1
def test_roles_viewing
    puts '[-] Test1: Checking if Current User can check existing roles'.cyan
    path = '/d2l/api/lp/1.4/roles/'
    http_method = 'GET'
    test_uri = create_authenticated_uri(path, http_method)
    puts '[-] Authenticated URI Created For: ' + path
    # General Brightspace API response behaviors
    get_query(test_uri)
    puts "[+] Test1 Succeeded\n".green
rescue
    puts '[!] Test1 failed'.red
end

# Test 2
def test_whoami
    puts "[-] Test2: Getting Current User's WhoAmI".cyan
    path = '/d2l/api/lp/1.4/users/whoami'
    http_method = 'GET'
    test_uri = create_authenticated_uri(path, http_method)
    puts '[-] Authenticated URI Created: ' + path
    # General Brightspace API response behaviors
    get_query(test_uri)
    puts "[+] Test2 Succeeded\n".green
rescue
    puts '[!] Test2 failed'.red
end

# TEST 3
def test_create_user
    puts '[-] Test3: testing create sample user data function'.cyan
    payload = { 'OrgDefinedId' => '', # String
                'FirstName' => 'TestUser', # String
                'MiddleName' => 'Test', # String
                'LastName' => 'Test', # String
                'ExternalEmail' => nil, # String (nil or well-formed email addr)
                'UserName' => 'test12345abcd', # String
                'RoleId' => 110, # number
                'IsActive' => false, # bool
                'SendCreationEmail' => false, # bool
              }
    create_user_data(payload)
    puts "[+] Test3 Succeeded\n".green
rescue => error
    ap error
    puts "[!] Test3 failed\n".red
    # ap error.backtrace
end

# Test 4
def test_update_user
    puts '[-] Test4: testing update sample user data function'.cyan
    newData = {
        'OrgDefinedId' => '',
        'FirstName' => 'TestUser',
        'MiddleName' => 'changedName',
        'LastName' => 'Test',
        'ExternalEmail' => nil,
        'UserName' => 'test12345a',
        'Activation' => {
            'IsActive' => false
        }
    }
    update_user_data(48558, newData) # TCP failed?
    puts "[+] Test4 Succeeded\n".green
rescue => error
    ap error
    ap error.backtrace
    puts "[!] Test4 failed\n".red
end

# Test 5
def test_who_another_user_is(id)
    puts "[-] Test5: Getting Current User's Ability to view other user profiles".cyan
    path = '/d2l/api/lp/1.4/users/' + id # '/d2l/api/lp/1.4/users/whoami'
    http_method = 'GET'
    test_uri = create_authenticated_uri(path, http_method)
    puts '[-] Authenticated URI Created: ' + path
    # General Brightspace API response behaviors
    get_query(test_uri)
    puts "[+] Test5 Succeeded\n".green
rescue
    puts '[!] Test5 failed'.red
end

def test_search_by_username(username)
    puts '[-] Test6: Using brightspace search functionality by UserName'.cyan
    path = '/d2l/api/lp/1.4/users/' + '?UserName=' + username
    http_method = 'GET'
    test_uri = create_authenticated_uri(path, http_method)
    puts '[-] Searching for: ' + username
    # General Brightspace API response behaviors
    get_query(test_uri)
    puts "[+] Test6 Succeeded\n".green
rescue
    puts '[!] Test6 failed'.red
end

# test_roles_viewing
# test_whoami
test_create_user
# test_update_user
# test_who_another_user_is('47906')
# test_search_by_username('test12345abc')
