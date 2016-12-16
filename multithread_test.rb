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
    multithreaded_search_timed_test("jon",(17..17))
end
multithreaded_search_test
