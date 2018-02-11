#!/usr/bin/env ruby

# download URL, extract magnet links, add to transmission through rpc

require 'open-uri'
require 'uri'
require 'transmission' # gem install transmission-ng

uris = URI.extract(File.read(open(ARGV[0])))

magnets = uris.reject { |e| !(e.to_s.start_with?("magnet:")) }

t = Transmission.new({
  :host => '127.0.0.1',
  :port => 9091,
#  :user => 'admin',
#  :pass => 'admin'
})

magnets.each do |magnet|
	t.add_magnet(magnet)
end
