require_relative "requests"
require_relative "org_unit"
########################
# SEMESTER:#############
########################

# Creates a semester based upon a merged result from merging a preformatted
# payload and the inputed semester data. This is then created server-side
# via executing a POST http method using a predefined path and the new payload.
def create_semester_data(semester_data)
    # Define a valid, empty payload and merge! with the semester_data. Print it.
    payload = { 'Type' => 5, # Number:D2LID
                'Name' => 'Winter 2013 Semester', # String
                'Code' => '201701', # String #YearNUM where NUM{sp:01,su:06,fl:08}
                'Parents' => [6606], # ARR of Number:D2LID
              }.merge!(semester_data)
    #ap payload
    path = "/d2l/api/lp/#{$version}/orgstructure/"
    _post(path, payload)
    puts '[+] Semester creation completed successfully'.green
end

# This retrieves all semesters via getting all children from the main
# organization and filtering them by the default data type of semesters.
#
# Returns: Array of all semester JSON formatted data
def get_all_semesters
  path = "/d2l/api/lp/#{$version}/orgstructure/6606/children/?ouTypeId=5"
  _get(path)
end

# Retrieves a semester by a particular id. This is done by referencing it by
# its org unit id in the organization and then performing a get request on it.
#
# return: JSON of org unit properties.
def get_semester_by_id(org_unit_id)
  path = "/d2l/api/lp/#{$version}/orgstructure/" + org_unit_id.to_s
  _get(path)
  # return json of org_unit properties
end

# Rather than retrieving all semesters, this retrieves all semesters by a
# particular string. First, a boolean is created where it is assumed the
# semester is not found. Then an array is created with all the 'found' semesters
# assuming none are found, but providing the structure to still return uniform
# data that can be iterated. Then, by iterating through all semesters and only
# storing ones that conform to the search string, all matched semesters are then
# returned.
#
# Returns: Array of all semester JSON formatted data (with search string in name)
def get_semester_by_name(search_string)
  semester_not_found = true
  semester_results = []
  puts "[+] Searching for semesters using search string: \'#{search_string}\'".yellow
  results = get_all_semesters
  results.each do |x|
      if x['Name'].downcase.include? search_string.downcase
          semester_not_found = false
          semester_results.push(x)
      end
  end
  if semester_not_found
      puts '[-] No semesters could be found based upon the search string.'.yellow
  end
  semester_results
end

# This is simply a helper function that can assist in preformatting a path
# that conforms to the required 'Path' for updating semester data.
#
# returns: preformatted semester 'Path' string
def create_semester_formatted_path(org_id, code)
    "/content/enforced/#{org_id}-#{code}/"
end

# Updates a semester's data via merging a preformatted payload with the new
# semester data. The 'path' is then initialized using a defined org_unit_id
# and the semester is then updated via the newly defined payload and the path.
def update_semester_data(org_unit_id, semester_data)
    # Define a valid, empty payload and merge! with the semester_data. Print it.
    payload = { # Can only update NAME, CODE, and PATH variables
        'Identifier' => org_unit_id.to_s, # String: D2LID // DO NOT CHANGE
        'Name' => 'NAME', # String
        # String #YearNUM where NUM{sp:01,su:06,fl:08}  | nil
        'Code' => 'REQUIRED',
        # String: /content/enforced/IDENTIFIER-CODE/
        'Path' => create_semester_formatted_path(org_unit_id.to_s, 'YEAR01'),
        'Type' => { # DO NOT CHANGE THESE
            'Id' => 5, # <number:D2LID>
            'Code' => 'Semester', # <string>
            'Name' => 'Semester', # <string>
        }
    }.merge!(semester_data)
    # print out the projected new data
    #puts '[-] New Semester Data:'.yellow
    #ap payload
    # Define a path referencing the course data using the course_id
    path = "/d2l/api/lp/#{$version}/orgstructure/#{org_unit_id}"
    puts '[-] Attempting put request (updating orgunit)...'
    _put(path, payload)
    puts '[+] Semester update completed successfully'.green
end

# This function provides the means to put the semester data into the recycling
# bin. A path is then created using the org_unit_id argument. Once this is done
# the post http method is then completed in order to officially recycle the data
def recycle_semester_data(org_unit_id)
    # Define a path referencing the user data using the user_id
    puts '[!] Attempting to recycle Semester data referenced by id: ' + org_unit_id.to_s
    path = "/d2l/api/lp/#{$version}/orgstructure/recyclebin/" + org_unit_id.to_s + '/recycle' # setup user path
    _post(path, {})
    puts '[+] Semester data recycled successfully'.green
end

# Rather than recycling a semester by a specific id, this function can recycle
# all semesters that match a particular name. The names must be exactly the same
# as the "name" argument. Each name that is the exact same as this argument is
# then recycled, iteratively.
def recycle_semester_by_name(name)
  results = get_semester_by_name(name)
  results.each do |semester_match|
    if semester_match["Name"] == name
      recycle_semester_data(semester_match["Identifier"])
    end
  end
end
