require 'sinatra'
require "json"
require_relative "topchan/data"

get '/frank-says' do
  'Put this in your pipe & smoke it!'
end

get "/boards" do
    content_type :json
    Topchan::Data.get_boards.to_json
end

get "/:board/threads" do
    content_type :json
    Topchan::Data.get_threads(params["board"]).to_json
end

get "/:board/:thread/posts" do
    content_type :json
    Topchan::Data.get_posts(params["board"], params["thread"]).to_json
end

get "/:board/:thread/:post/links" do
    content_type :json
    Topchan::Data.get_links(params["board"], params["thread"], params["post"]).to_json
end
