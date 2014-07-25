require 'ap'
require 'ruby-d2l'

puts "USERNAME: "
username = gets.chomp
puts "PASSWORD: "
password = gets.chomp

RubyD2L.configure do |config|
  config.username = username
  config.password = password
  config.site_url = 'https://wiutest.desire2learn.com'
end

result = RubyD2L::OrgUnit.get_semester_by_code(semester_code: '17')
if result == false
  ap 'Creating missing semester object'
  create_result = RubyD2L::OrgUnit.create_semester(semester_name: 'Fall 2012', semester_code: '201208', path: '/content/semesters/201208')
  ap create_result
end

ap result