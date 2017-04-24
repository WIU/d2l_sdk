#Is this the production environment?
require 'json'
@production = true
@debug = true
# Conditional on whether this is production or test server
config_file_name = 'd2l_config.json'
# If a configuration file already exists...
if File.exist?(config_file_name)
  config_file = File.read(config_file_name)
  config = JSON.parse(config_file)
  puts "[+] Configuration Variables:" if @debug
  puts "[-] hostname: #{config["hostname"]}" if @debug
  $hostname = config["hostname"]
  puts "[-] user_id: #{config["user_id"]}" if @debug
  $user_id = config["user_id"]
  puts "[-] user_key: #{config["user_key"]}" if @debug
  $user_key = config["user_key"]
  puts "[-] app_id: #{config["app_id"]}" if @debug
  $app_id = config["app_id"]
  puts "[-] app_key: #{config["app_key"]}" if @debug
  $app_key = config["app_key"]
# else if a configuration file doesnt exist, create one and load the config vars!
else
  puts "[!] No file by the name 'd2l_config.json' found!"
  puts "[-] Initializing 'd2l_config.json' in current directory..\n"\
       "    Please enter the following information..."
  # host of D2L server
  print "hostname: "
  $hostname = gets.chomp.gsub(/'|\"|https:\/\/|http:\/\/|/,'').strip
  # api-user id
  print "user_id: "
  $user_id = gets.chomp.gsub(/'|\"/,'').strip
  # api-user key
  print "user_key: "
  $user_key = gets.chomp.gsub(/'|\"/,'').strip
  # app id (received from apitesttool)
  print "app_id: "
  $app_id = gets.chomp.gsub(/'|\"/,'').strip
  # app key (same as app id retrieval)
  print "app_key: "
  $app_key = gets.chomp.gsub(/'|\"/,'').strip

  config_hash = {
    "hostname" => $hostname,
    "user_id" => $user_id,
    "user_key" => $user_key,
    "app_id" => $app_id,
    "app_key" => $app_key
  }
  json = JSON.pretty_generate(config_hash)
  puts json if @debug
  # puts JSON.parse(json)["hostname"] if @debug
  config = File.new("d2l_config.json","w")
  config.puts(json)
  config.close
end
