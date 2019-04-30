#!/usr/bin/env ruby

require_relative "topchan/net"
require_relative "topchan/data"


board = "mu"
Topchan::Net.get_threads(board).shuffle.each do |thread|

    thread_no = thread["no"]
    last_modified = thread["last_modified"]

    if Topchan::Data.update_thread(board, thread_no, last_modified)

        puts "Updating #{board}/#{thread_no}"

        Topchan::Net.get_posts(board, thread_no).each do |post|

            post_no = post["no"]
            com = post["com"]

            Topchan::Data.insert_post(board, thread_no, post_no, com)
        end
    end
end

# Topchan::Net.get_boards().shuffle.each do |board|

#     puts "Board /#{board}/"

#     Topchan::Net.get_threads(board).shuffle.each do |thread|

#         thread_no = thread["no"]
#         last_modified = thread["last_modified"]

#         if Topchan::Data.update_thread(board, thread_no, last_modified)

#             puts "Updating #{board}/#{thread_no}"

#             Topchan::Net.get_posts(board, thread_no).each do |post|

#                 post_no = post["no"]
#                 com = post["com"]

#                 Topchan::Data.insert_post(board, thread_no, post_no, com)
#             end
#         end
#     end
# end
