require_relative "lib/d2l_sdk"

def format_user_enrollments(enrollments, id)
  #puts enrollments["PagingInfo"]
  response = "/code "
  #prev_enrollment = ""
  prev_semester = ""
  # append <=100 enrollments to the response string.
  filtered = enrollments["Items"].select{|ou| ou["OrgUnit"]["Type"]["Id"] == 3 && ou[]}
  filtered.sort_by{|hash| hash["OrgUnit"]["Code"]}.each do |enrollment|
    course_info = get_course_by_id(enrollment["OrgUnit"]["Id"])
    ap course_info if course_info["OrgUnit"]["Name"][0..5].downcase.include? "cl"
    end_date = course_info["EndDate"]
    if course_info["Semester"].nil?
      response << "\nNO SEMESTER: #{enrollment["OrgUnit"]["Name"][0..34]}(#{enrollment["OrgUnit"]["Id"]})".ljust(45) + "\n"
      next
    end
    puts "Carrying on.."
    course_semester = course_info["Semester"]["Code"]
    response << "\n::#{course_semester}::\n" if prev_semester != course_semester
    prev_semester = course_semester
    puts course_info
    next if end_date.nil?
    puts 'end date valid'
    #next if Time.parse(end_date) < Time.now
    course = "#{enrollment["OrgUnit"]["Name"][0..34]}(#{enrollment["OrgUnit"]["Id"]}):".ljust(45)
    # enrollment_code_and_sect = course.split("-").each{|item|item.uppercase.strip!}[0..1].join(" - ")
    # next if prev_enrollment == enrollment_code_and_sect
    response << course + " #{enrollment["Role"]["Name"]}\n"
  end
  response
end



id = "api-user" #response.args[1] # ID / Username

id = id[/[^@]+/] #remove email addressing if its there.
user = get_user_by_username(id)
if user.nil? # user exists
  puts("Username '#{id}' could not be found.")
else # user does not exist
  user_id = user["UserId"]
  enrollments = get_all_enrollments_of_user(user_id)
  if enrollments.nil? # no enrollments or somehow invalid get
    puts("Username '#{id}' could not be found.")
  else
    puts format_user_enrollments(enrollments, id)
  end
end
