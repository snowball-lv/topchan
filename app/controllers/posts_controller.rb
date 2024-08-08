class PostsController < ApplicationController
  
  PER_PAGE = 10

  def show
    @board = DbBoard.where(board: params[:board]).take
    # @thread = @board.db_threads.where(no: params[:thread]).take
    # @post = @thread.db_posts.where(no: params[:post]).take
    @post = DbPost.where(no: params[:post])
        .joins(:db_thread).where(db_threads: { db_board: @board })
        .take
    @thread = @post.db_thread
  end

  def index
    @omit_op = params[:omit_op] == "true"
    @board = DbBoard.where(board: params[:board]).take
    @page = (params[:page] || 0).to_i
    @from = @page * PER_PAGE
    @to = @from + PER_PAGE
    # @posts = DbPost
    #     .joins("left outer join db_references on db_posts.id = db_references.ref_id")
    #     .group(:id)
    #     .order("COUNT(db_references.post_id) DESC")
    #     .offset(@from)
    #     .limit(PER_PAGE)
    @posts = get_posts(@board)
    if @omit_op
      @posts = @posts.joins(:db_thread)
          .where.not("db_posts.no = db_threads.no")
    end
    @num_posts = @posts.count
    @posts = @posts
        .joins("left outer join db_references on db_posts.id = db_references.ref_id")
        .group(:id)
        .order("COUNT(db_references.post_id) DESC")
        .offset(@from)
        .limit(PER_PAGE)
  end

  private

  def get_posts(board)
    return DbPost.all if board.nil?
    DbPost.joins(:db_thread).where(db_threads: { db_board: board })
  end

end
