require_relative "requests"
########################
# SEMESTER:#############
########################
def create_semester_data(semester_data)
    # Define a valid, empty payload and merge! with the semester_data. Print it.
    payload = { 'Type' => 5, # String
                'Name' => 'Winter 2013 Semester', # String
                'Code' => '201701', # String #YearNUM where NUM{sp:01,su:06,fl:08}
                'Parents' => [6606], # String
              }.merge!(semester_data)
    ap payload
    # Define a path referencing the course data using the course_id
    path = "/d2l/api/lp/#{$version}/orgstructure/"
    _post(path, payload)
    puts '[+] Semester creation completed successfully'.green
end

def get_all_semesters
  path = "/d2l/api/lp/#{$version}/orgstructure/6606/children/?ouTypeId=5"
  _get(path)
end

def get_semester_by_name(org_unit_name)
  semester_not_found = true
  semester_results = []
  puts "[+] Searching for semesters using search string: \'#{org_unit_name}\'".yellow
  path = "/d2l/api/lp/#{$version}/orgstructure/6606/children/?outTypeId=5"
  results = _get(path)
  results.each do |x|
      if x['Name'].downcase.include? org_unit_name.downcase
          semester_not_found = false
          semester_results.push(x)
      end
  end
  if semester_not_found
      puts '[-] No semesters could be found based upon the search string.'.yellow
  end
  semester_results
end

def update_semester_data(org_unit_id, semester_data)
    # Define a valid, empty payload and merge! with the semester_data. Print it.
    payload = { # Can only update NAME, CODE, and PATH variables
        'Identifier' => org_unit_id.to_s, # String: D2LID // DO NOT CHANGE
        'Name' => 'NAME', # String
        # String #YearNUM where NUM{sp:01,su:06,fl:08}  | nil
        'Code' => 'REQUIRED',
        # String: /content/enforced/IDENTIFIER-CODE/
        'Path' => '/content/enforced/' + org_unit_id.to_s + '-YEAR01/',
        'Type' => { # DO NOT CHANGE THESE
            'Id' => 5, # <number:D2LID>
            'Code' => 'Semester', # <string>
            'Name' => 'Semester', # <string>
        } # String #YearNUM where NUM{sp:01,su:06,fl:08}
    }.merge!(semester_data)
    # print out the projected new data
    puts '[-] New Semester Data:'.yellow
    ap payload
    # Define a path referencing the course data using the course_id
    path = "/d2l/api/lp/#{$version}/orgstructure/" + org_unit_id.to_s
    puts '[-] Attempting put request (updating orgunit)...'
    _put(path, payload)
    puts '[+] Semester update completed successfully'.green
end

def recycle_semester_data(org_unit_id)
    # Define a path referencing the user data using the user_id
    puts '[!] Attempting to recycle Semester data referenced by id: ' + org_unit_id.to_s
    path = "/d2l/api/lp/#{$version}/orgstructure/recyclebin/" + org_unit_id.to_s + '/recycle' # setup user path
    _post(path, {})
    puts '[+] Semester data recycled successfully'.green
end
