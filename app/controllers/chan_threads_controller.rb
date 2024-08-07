class ChanThreadsController < ApplicationController

    def show
        @board = DbBoard.where(board: params[:board]).take
        @thread = @board.db_threads.where(no: params[:no]).take
    end
end
