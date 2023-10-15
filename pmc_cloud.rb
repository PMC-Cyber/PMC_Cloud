#!/usr/bin/env ruby
# encoding: UTF-8
require 'net/http'
require 'open-uri'
require 'json'
require 'socket'
require 'optparse'

class String
def black;          "\e[30m#{self}\e[0m" end
def red;            "\e[31m#{self}\e[0m" end
def green;          "\e[32m#{self}\e[0m" end
def italic;         "\e[3m#{self}\e[23m" end
def cyan;           "\e[36m#{self}\e[0m" end
end
def banner()
  
puts "\n"
puts" "
puts "amit"
system("clear")
puts " "
puts"Bahasa Yang di Gunakan : Ruby ".red.italic
puts
puts"██████╗ ███╗   ███╗ ██████╗     ██████╗██╗      ██████╗ ██╗   ██╗██████╗ ".green
puts"██╔══██╗████╗ ████║██╔════╝    ██╔════╝██║     ██╔═══██╗██║   ██║██╔══██╗".green
puts"██████╔╝██╔████╔██║██║         ██║     ██║     ██║   ██║██║   ██║██║  ██║".green
puts"██╔═══╝ ██║╚██╔╝██║██║         ██║     ██║     ██║   ██║██║   ██║██║  ██║".green
puts"██║     ██║ ╚═╝ ██║╚██████╗    ╚██████╗███████╗╚██████╔╝╚██████╔╝██████╔╝".green
puts"╚═╝     ╚═╝     ╚═╝ ╚═════╝     ╚═════╝╚══════╝ ╚═════╝  ╚═════╝ ╚═════╝ Version 0.5  ".green.italic
puts
puts "Tool for identifying real IP of CloudFlare protected website.".italic.cyan
puts
puts " Author  : ./B8".italic.cyan
puts " GitHub  : https://github.com/Unlimited-Crack-You".italic.cyan
puts " Version : Versi 0.5".italic.cyan

puts "\n"
end

options = {:bypass => nil, :massbypass => nil}
parser = OptionParser.new do|opts|

    opts.banner = "Example: ruby pmc_cloud.rb -b <your target> or ruby pmc_cloud.rb --byp <your target>"
    opts.on('-b ','--byp ', 'Discover real IP (bypass CloudFlare)', String)do |bypass|
    options[:bypass]=bypass;
    end

    opts.on('-o', '--out', 'Next release.', String) do |massbypass|
        options[:massbypass]=massbypass

    end

    opts.on('-h', '--help', 'Help') do
        banner()
        puts opts
        puts "Example: ruby pmc_cloud.rb -b discordapp.com or ruby pmc_cloud.rb --byp discordapp.com"
        exit
    end
end

parser.parse!


banner()

if options[:bypass].nil?
    puts "Insert URL -b or --byp"
else
	begin
	option = options[:bypass]
	payload = URI ("http://www.crimeflare.us:82/cgi-bin/cfsearch.cgi")
	request = Net::HTTP.post_form(payload, 'cfS' => options[:bypass])

	response =  request.body
	nscheck = /No working nameservers are registered/.match(response)
	if( !nscheck.nil? )
		puts "[-] No valid address - are you sure this is a CloudFlare protected domain?\n"
		exit
	end
	regex = /(\d*\.\d*\.\d*\.\d*)/.match(response)
	if( regex.nil? || regex == "" )
		puts "[-] No valid address - are you sure this is a CloudFlare protected domain?\n"
		exit
	end
rescue
	puts "Fatail Erro !"
end
	ip_real = IPSocket.getaddress (options[:bypass])

	puts "[+] Site analysis: #{option} ".green
	puts "[+] CloudFlare IP is #{ip_real} ".green
	puts "[+] Real IP is #{regex}".green
	target = "http://ipinfo.io/#{regex}/json"
	url = URI(target).read
	json = JSON.parse(url)
	puts "[+] Hostname: ".green + json['hostname'].to_s
	puts "[+] City: ".green  + json['city']
	puts "[+] Region: ".green + json['country']
	puts "[+] Location: ".green + json['loc']
	puts "[+] Organization:".green + json['org']

end
