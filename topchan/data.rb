require "sequel"


module Topchan; end
module Topchan::Data
    
    DB = Sequel.connect("sqlite://topchan.db")

    DB.create_table? :threads do
        String :board_id
        Bignum :thread_id
        DateTime :last_modified
        primary_key [:board_id, :thread_id]
    end

    DB.create_table? :posts do
        String :board_id
        Bignum :thread_id
        Bignum :post_id
        String :comment
        primary_key [:board_id, :thread_id, :post_id]
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

    def self.get_boards()
        DB[:threads].select(:board_id).distinct.map(:board_id)
    end

    def self.get_threads(board)
        DB[:threads].where(board_id: board).select_map(:thread_id)
    end

    def self.get_posts(board, thread)
        DB[:posts].where(board_id: board, thread_id: thread).select_map([:post_id, :comment])
    end

    def self.delete_thread(board, thread)
        DB[:threads].where(board_id: board, thread_id: thread).delete
    end
end
