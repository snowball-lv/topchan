class DbThread < ApplicationRecord
  belongs_to :db_board
  has_many :db_posts
end
