#!/usr/bin/env ruby

require "nokogiri"
require_relative "topchan/data"


# board = Topchan::Data.get_boards().sample
board = "mu"
threads = Topchan::Data.get_threads(board)

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

Topchan::Data.erase_links

threads.each do |t|
    posts = Topchan::Data.get_posts(board, t)
    posts.each do |post|
        links = get_links(post.last)
        links.each do |ref_id|
            Topchan::Data.create_link(post.first, ref_id)
            puts "#{post.first} -> #{ref_id}"
        end
    end
end
