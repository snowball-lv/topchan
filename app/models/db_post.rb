class DbPost < ApplicationRecord
  belongs_to :db_thread

  def get_thread_no
    return db_thread.no
  end

  def get_board_code
    return db_thread.db_board.board
  end

  def get_com
    return JSON.parse(json)["com"]
  end
end
