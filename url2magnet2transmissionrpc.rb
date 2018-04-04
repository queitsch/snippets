#!/usr/bin/env ruby

# download URL, extract magnet links, add to transmission through rpc
# usage: ruby url2magnet2transmissionrpc.rb [URL]
# put URL in quotes to avoid shell interpretation

require 'open-uri'
require 'uri'
require 'io/console'
require 'transmission' # gem install transmission-ng

if ARGV.length != 1
	puts "usage: ruby url2magnet2transmissionrpc.rb [URL]; put URL in quotes"
	exit
end

uris = URI.extract(File.read(open(ARGV[0])))

magnets = uris.reject { |e| !(e.to_s.start_with?("magnet:")) }

puts "will add magnets with these display names to transmission:"
puts

magnets.each do |m|
	a = URI.decode_www_form(m.split('?')[1])#.values_at(0,1)
	puts a[0][1] + " " + a[1][1]	 
end

puts
puts "press 'y' to continue, anything else to abort"

prompt = STDIN.gets.chomp
exit unless prompt == 'y'

puts "sending to transmission..."

t = Transmission.new({
	:host => '127.0.0.1',
	:port => 9091,
#  :user => 'admin',
#  :pass => 'pass'
})

magnets.each do |m|
	puts m
	t.add_magnet(m)
puts "done."
end
