class BoardsController < ApplicationController

  def index
    @boards = DbBoard.all
  end

  def show
    @board = DbBoard.where(board: params[:id]).take
  end

end
