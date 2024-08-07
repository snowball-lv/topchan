class PostsController < ApplicationController
  
  def show
    @board = DbBoard.where(board: params[:board]).take
    @thread = @board.db_threads.where(no: params[:thread]).take
    @post = @thread.db_posts.where(no: params[:post]).take
  end

end
