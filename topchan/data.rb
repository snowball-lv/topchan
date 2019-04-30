require "sequel"


module Topchan; end
module Topchan::Data
    
    DB = Sequel.connect("sqlite://topchan.db")

    DB.create_table? :threads do
        primary_key :id
        String :board_id
        Bignum :thread_id
        DateTime :last_modified
        # primary_key [:board_id, :thread_id]
    end

    DB.create_table? :posts do
        primary_key :id
        String :board_id
        Bignum :thread_id
        Bignum :post_id
        String :comment
        # primary_key [:board_id, :thread_id, :post_id]
    end

    DB.create_table? :links do
        primary_key :id
        Bignum :post_id
        Bignum :ref_id
    end

    def self.insert_post(board, thread, post, comment)
        posts = DB[:posts].where(board_id: board, thread_id: thread, post_id: post)
        if posts.empty?
            posts.insert(board_id: board, thread_id: thread, post_id: post, comment: comment)
            puts "New post #{post}"
        end
    end

    def self.update_thread(board, thread, last_modified)
        threads = DB[:threads].where(board_id: board, thread_id: thread)
        if threads.empty?
            threads.insert(board_id: board, thread_id: thread, last_modified: last_modified)
            return true
        else
            threads = threads.where(Sequel[:last_modified] < last_modified)
            if threads.empty?
                return false
            else
                threads.update(last_modified: last_modified)
                return true
            end
        end
    end
    
    def self.create_link(post_id, ref_id)
        DB[:links].insert(post_id: post_id, ref_id: ref_id)
    end
    
    def self.erase_links
        DB[:links].delete
    end

    def self.get_boards()
        DB[:threads].select(:board_id).distinct.map(:board_id)
    end

    def self.get_threads(board)
        DB[:threads].where(board_id: board).select_map(:thread_id)
    end

    def self.get_posts(board, thread)
        DB[:posts].where(board_id: board, thread_id: thread).select_map([:id, :post_id, :comment])
    end
    
    def self.get_post(board, thread, post)
        DB[:posts].where(board_id: board, thread_id: thread, post_id: post).select_map([:id, :post_id, :comment]).first
    end

    def self.get_links(board, thread, post)
        id = self.get_post(board, thread, post).first
        DB[:links].where(post_id: id).select_map([:ref_id])
    end

    def self.delete_thread(board, thread)
        DB[:threads].where(board_id: board, thread_id: thread).delete
    end
end
