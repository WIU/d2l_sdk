require_relative 'lib/d2l_api'

def multithreaded_search_timed_test(search_string,range)
    times = []
    (range).each do |threads|
      start = Time.now
      #print "testing with #{threads}..."
      result = multithreaded_user_search(search_string, threads)
      time_info = {
        "thread-amt"=> threads,
        "time"=> (Time.now - start).to_s
      }
      times.push([result, time_info])
    end
    ap times
end

def multithreaded_search_test
    #ap multithreaded_user_search("test", (17))
    if ARGV.size != 0
      puts "looking for user #{ARGV[0]}"
      multithreaded_search_timed_test(ARGV[0].to_s,(17..17))
    else
      multithreaded_search_timed_test("jon",(17..17))
    end
end

def test_out_of_range
    path = "/d2l/api/lp/#{$version}/users/?bookmark=" + "99000"
    ap _get(path)
    #Should return a response with an empty array "Items"
end

#delete_user_data(48606)
get_user_by_username('test-ruby-user123')
#multithreaded_search_test
#test_out_of_range
