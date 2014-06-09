require 'ap'
require 'ruby-d2l'

RubyD2L.configure do |config|
  config.username = 'websvcs'
  config.password = 'd2lw3bsvcs'
  config.site_url = 'https://wiutest.desire2learn.com'
end

result = RubyD2L::OrgUnit.get_semester_by_code(semester_code: '201208')
if result == false
  ap 'Creating missing semester object'
  create_result = RubyD2L::OrgUnit.create_semester(semester_name: 'Fall 2012', semester_code: '201208', path: '/content/semesters/201208')
  ap create_result
end
