require_relative "../lib/d2l_sdk"

not_enabled = get_config_var_values("d8060001-0000-0000-0000-000000000000")
ap not_enabled
while(true)
    new_var_state = get_config_var_values("d8060001-0000-0000-0000-000000000000")
    puts "def: #{new_var_state["DefaultValue"]} || sys:#{new_var_state["SystemValue"]} || org:#{new_var_state["OrgValue"]} || #{Time.new.inspect}"
    if not_enabled != new_var_state
      break
    end
    puts "sleeping 60 seconds..."
    sleep 60
end
