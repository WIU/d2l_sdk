# require 'd2l_sdk'
require 'net/ldap' # gem install net-ldap
require 'highline/import' # gem install highline
require "CSV"
require "awesome_print"
# in this dir, there must be a folder named 'export_jobs' with
# an instr.csv file to filter the exported job csv.
def get_current_enrollments
  users = {}
  file_path = "/Users/ajk142/Documents/d2l_api/tests/export_jobs/Enrollments\ and\ Withdrawals-01-18-2017T09-01-12.csv.csv"
  CSV.foreach(file_path, headers: true) do |row|
    if !users.key?(row['Org Defined Id'])
      users["#{row['Org Defined Id']}"] =
      {
        "instr" => [],
        "enrollments" => [],
        "wiuId" => nil,

      }
    end
    starnum = row["Org Unit Code"][-5..-1]
    users["#{row['Org Defined Id']}"]["enrollments"].push(starnum).uniq!
  end
  users
end

def get_uid(users = nil)
  # Active Directory credentials
  port = 389
  @ad = false
  username = ask("Enter username: ") { |q| q.echo = false }
  password = ask("Enter password: ") { |q| q.echo = false }
  credentials = {
    :method => :simple,
    :username => "wiu-ad\\#{username}", # expected wiu-ad\USERNAME if @ad
    :password => password
  }
  base = 'dc=ad,dc=wiu,dc=edu' if @ad
  host = 'ad.wiu.edu' if @ad
  host = "ldap.wiu.edu" if !@ad
  base = "dc=wiu,dc=edu" if !@ad
  credentials[:username] = "cn=#{username}" if !@ad
  ap credentials[:username]
  ldap = Net::LDAP.new(:host => host, :port => port, :encryption => 'TLSv1',
                       :base => base, :auth => credentials)
  if ldap.bind && users != nil
    puts "success"
    puts "connection initialized to '#{host}'"
    users.each do |key, value|
      search_param = key
      attrs = ["wiuId"]
      search_filter = Net::LDAP::Filter.eq("wiuId", search_param)
      puts "searching '#{host}' for '#{search_param}'"
      ldap.search(:filter => search_filter, :attributes => attrs) { |item|
        users[key]["wiuId"] = item["uidnumber"][0]
      }
    end
    users
  elsif ldap.bind
    puts "success"
    puts "connection initialized to '#{host}'"
    search_param = "a*.com"
    search_filter = Net::LDAP::Filter.eq("mail", search_param)
    attrs = ["mail", "cn", "sn", "objectclass"]
    puts "searching '#{host}' for '#{search_param}'"
    puts ldap.search(:filter => search_filter, :base => base, :return_result => false,
                :attributes => attrs,:return_referrals => true ,:deref => Net::LDAP::DerefAliases_Always) { |item|
      puts "search result successful"
      puts item.attribute_names
    }
    ldap.get_operation_result
  else
    puts "failed"
    ap ldap.get_operation_result
    nil
  end
end
#ap get_uid(get_current_enrollments)
ap get_uid
# Users = {}
# CSV.foreach(starall_fname) do |row|
  # Get username through LDAP (email.gsub "@wiu.edu" "")
  # if not in Users yet, create a key-pair
  # Users[user_id] =
  #  {
  #    instr => []
  #    courses => [] ##Include cl_off_??? into this?
  #    username => ldap_return_value
  #  }
  # Users[user_id][courses].push(course_code)
  # ##Compare enrollments and starall
  # CSV.foreach(formatted_enrollments) do |row|
  #   ##Assume if course enrollment not in starall, just unenroll?
  #   if row.include? "enroll" && !row.include? "unenroll"
  #     Users[user_id][courses].delete(course_code) ##already done, so del dupes
  #   # elsif, unenroll?
  # Then apply changes from mainframe
  #   course_ou_id = get_section_by_section_code(create_semester_code(starnum, course_date))
  #   user = get_user_by_username(username)
  #   user_id = user['OrgDefinedId']
  #   payload = {'OrgUnitId' => course_ou_id, 'UserId' => user_id, 'RoleId' => student_role_id}
  #   create_user_enrollment(payload) # Enroll the user!
  #   ## Not listed...delete enrollment for students && instructors?
  #   #### using instr array?
  #
