#!/usr/bin/env ruby

require "nokogiri"
require_relative "topchan/data"


# board = Topchan::Data.get_boards().sample
board = "mu"
thread = Topchan::Data.get_threads(board).sample
posts = Topchan::Data.get_posts(board, thread)

# puts "/#{board}/#{thread}/#{post.first}"
# puts post.last
# puts

def get_links(comment)
    doc = Nokogiri::HTML(comment)
    links = doc.xpath("//a[contains(@class,'quotelink')]/@href").map(&:to_s)
    return links.select { |link|
        link =~ /^#p\d+$/
    }.map { |link|
        link.slice(2..-1)
    }
end

posts.each do |post|
    links = get_links(post.last)
    puts links
end
