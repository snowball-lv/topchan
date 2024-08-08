module PostsHelper
    
  def get_posts_query(board, page, omit_op)
    params = {}
    params[:board] = board.board unless board.nil?
    params[:page] = page unless page.nil?
    params[:omit_op] = omit_op unless omit_op.nil?
    "/posts/?#{params.to_query}"
  end

end
