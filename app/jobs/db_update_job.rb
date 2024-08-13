class DbUpdateJob < ApplicationJob
  queue_as :default

  def perform(*args)
    puts "Running db update job"
    @new_boards = 0
    @new_threads = 0
    @updated_threads = 0
    @new_posts = 0
    @new_refs = 0
    update_db
    update_references
    # job report
    puts "new_boards #{@new_boards}"
    puts "new_threads #{@new_threads}"
    puts "updated_threads #{@updated_threads}"
    puts "new_posts #{@new_posts}"
    puts "new_refs #{@new_refs}"
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
        @new_boards += 1
      end
      update_board(db_board)
    end
  end

  def update_board(db_board)
    return unless ["po"].include?(db_board.board)
    puts "Updating /#{db_board.board}/ - #{db_board.title}"
    threads = @api.get_threads(db_board.board)
    threads.each do |th|
      
      # latest timestamp from web api
      last_modified = Time.at(th["last_modified"])

      # find or create thread object, set modified timestamp to 0
      db_thread = db_board.db_threads.find_or_create_by(no: th["no"]) do |db_thread|
        db_thread.no = th["no"]
        db_thread.last_modified = Time.at(0)
        @new_threads += 1
      end

      # update posts and update timestamp afterwards
      if last_modified > db_thread.last_modified
        update_thread(db_thread)
        db_thread.update(last_modified: last_modified)
        @updated_threads += 1
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
        db_post.json = JSON.generate(post)
        @new_posts += 1
      end
      # puts "Post /#{db_thread.db_board.board}/#{db_thread.no}/#{db_post.no}"
    end
  end

  def update_references
    # only process posts not already in the reference table
    posts = DbPost.where.not(id: DbReference.pluck(:post_id))
    posts.each do |post|
      refs = post.get_refs
      next if refs.empty?
      refs.each do |ref|
        link_ref(post, ref)
      end
    end
  end

  def link_ref(post, ref_post_no)
    board = post.db_thread.db_board
    ref_post = DbPost.where(no: ref_post_no)
        .joins(:db_thread).where(db_threads: { db_board: board })
        .take
    DbReference.find_or_create_by(post: post, ref: ref_post) do |ref|
      ref.post = post
      ref.ref = ref_post
      @new_refs += 1
    end
  end

end
