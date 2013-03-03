# requirements
require 'rss'
require 'open-uri'

# constants
RSS_FEED = 'http://urlquery.net/rss.php'


# code
rss_content = ""

# open rss feed and read data
open(RSS_FEED) do |f|
  rss_content = f.read
end

# parse RSS feed
rss = RSS::Parser.parse(rss_content, false)

# traversal
rss.items.each do |item|

  # show me only stuff that gets detected
  unless item.description.include?('No')
    url = item.title.gsub('urlQuery - ', '')

    # go to details page
    details = open(item.link).read()
    details.each_line do |l|
      if l.include?("exploit kit") && l.include?("color:red")
        puts "URL: #{url}"
        puts "Info: #{item.description.gsub(/. <br.*/, '')}"

        exploit_line = l.gsub(/.*color:red'>/, '').gsub(/<\/b>.*$/, '')
        puts "Detection: #{exploit_line}"
      end
    end
    
  end
end

