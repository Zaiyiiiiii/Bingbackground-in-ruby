require 'rexml/document'
require 'open-uri'
include REXML
require 'Win32API'
#require 'pathname'

module Bingmarket
	    $World = "en-WW"
        $USA = "en-US"
        $China = "zh-CN"
        $Japan = "ja-JP"
end

size = "1920x1080"
market = $China
count = 1
dir = ENV["HOMEDRIVE"] + ENV["HOMEPATH"] + "\\Documents\\Wallpapers"
if !FileTest.exist?(dir)
	Dir.mkdir("#{dir}")
end
#dir = File.dirname(__FILE__)
#Pathname.new(__FILE__).realpath.to_s.slice!(0,Pathname.new(__FILE__).realpath.to_s.size-13)
puts dir
url = "http://www.bing.com/hpimagearchive.aspx?format=xml&idx=0&n=#{count}&mkt=#{market}"

xml = String.new

open(url) do |f|
	xml << f.gets
end
Net::HTTP.start('www.bing.com') do |http|
	response = http.get('/hpimagearchive.aspx?format=xml&idx=0&n=#{count}&mkt=#{market}')
	puts response.value
end


xxml = REXML::Document.new open(url).gets
date0 = xxml.elements.each("/images/image/startdate/") {
	|e| $date = e.text
		puts $date
}

wurl = xxml.elements.each("/images/image/urlBase/") {
	|e| $urlBase = e.text
	puts $urlBase
}

desc = xxml.elements.each("/images/image/copyright/") {
	|e| $copyright = e.text
	puts $copyright
}

murl = "http://bing.com#{$urlBase}_#{size}.jpg"


file_name = murl.split('/').last
img_file = open(murl) { |f| f.read }
open("#{dir}\\#{file_name}", "wb") { |f| f.write(img_file) }


wallpaper ||= Win32API.new("user32.dll", "SystemParametersInfo", "llpl", "l")
wallpaper.call(20,0,"#{dir}/#{file_name}",0)

sleep(1.5)

#File.delete("#{file_name}")