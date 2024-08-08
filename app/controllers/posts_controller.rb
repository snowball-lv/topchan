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
    @page = (params[:page] || 0).to_i
    @from = @page * PER_PAGE
    @to = @from + PER_PAGE
    @posts = DbPost
        # .left_joins(:db_references)
        .joins("left outer join db_references on db_posts.id = db_references.ref_id")
        .group(:id)
        .order("COUNT(db_references.post_id) DESC")
        .offset(@from)
        .limit(PER_PAGE)
  end

end
