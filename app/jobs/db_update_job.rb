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
      puts "Updating /#{db_board.board}/ - #{db_board.title}"
    end
  end

end
