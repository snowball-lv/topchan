class PostsController < ApplicationController
  
  PER_PAGE = 10

  def show
    @board = DbBoard.where(board: params[:board]).take
    @thread = @board.db_threads.where(no: params[:thread]).take
    @post = @thread.db_posts.where(no: params[:post]).take
  end

  def index
    @page = (params[:page] || 0).to_i
    @from = @page * PER_PAGE
    @to = @from + PER_PAGE
    @posts = DbPost.offset(@from).limit(PER_PAGE).all
  end

end
