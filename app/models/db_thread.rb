class DbThread < ApplicationRecord
  belongs_to :db_board
  has_many :db_posts

  validates :no, :last_modified, presence: true
end
