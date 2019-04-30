#!/usr/bin/env ruby

require_relative "topchan/data"
require_relative "topchan/net"


OLD = {}

Topchan::Data.get_boards().each do |board|
    # puts "Board /#{board}/"
    OLD[board] = Topchan::Data.get_threads(board)
end

Topchan::Net.get_boards().each do |board|
    # puts "Board /#{board}/"
    Topchan::Net.get_threads(board).each do |thread|
        thread_no = thread["no"]
        OLD[board].delete(thread_no) if OLD[board]
    end
end

OLD.each do |board, threads|
    threads.each do |t|
        puts "Deleting /#{board}/#{t}/"
        Topchan::Data.delete_thread(board, t)
    end
end
