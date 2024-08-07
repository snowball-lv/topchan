class DbUpdateJob < ApplicationJob
  queue_as :default

  def perform(*args)
    puts "Running db update job"
    # unless MyHelpers.is_server_running?
    #   puts "Server isn't running, clearing crontab"
    #   system("whenever --clear-crontab")
    #   return
    # end
    update_db
  end
  
  private

  def update_db
    puts "Updating database"
    @api = ChanApi.new
    update_boards
  end

  def update_boards
    boards = @api.get_boards
    boards.each do |board|
      code = board["board"]
      db_board = DbBoard.find_or_create_by(board: code) do |db_board|
        db_board.board = board["board"]
        db_board.title = board["title"]
        db_board.meta_description = board["meta_description"]
      end
      update_board(db_board)
    end
  end

  def update_board(db_board)
    return unless db_board.board == "po"
    puts "Updating /#{db_board.board}/ - #{db_board.title}"
    threads = @api.get_threads(db_board.board)
    threads.each do |th|
      
      # latest timestamp from web api
      last_modified = Time.at(th["last_modified"])

      # find or create thread object, set modified timestamp to 0
      db_thread = db_board.db_threads.find_or_create_by(no: th["no"]) do |db_thread|
        db_thread.no = th["no"]
        db_thread.last_modified = Time.at(0)
      end

      # update posts and update timestamp afterwards
      if last_modified > db_thread.last_modified
        update_thread(db_thread)
        db_thread.update(last_modified: last_modified)
      else
        puts "Thread /#{db_thread.db_board.board}/#{db_thread.no} up to date"
      end

    end
  end

  def update_thread(db_thread)
    puts "Updating thread /#{db_thread.db_board.board}/#{db_thread.no}"
    posts = @api.get_posts(db_thread.db_board.board, db_thread.no)
    posts.each do |post|
      db_post = db_thread.db_posts.find_or_create_by(no: post["no"]) do |db_post|
        db_post.no = post["no"]
      end
      puts "Post /#{db_thread.db_board.board}/#{db_thread.no}/#{db_post.no}"
    end
  end

end
