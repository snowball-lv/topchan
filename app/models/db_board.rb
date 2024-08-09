class DbBoard < ApplicationRecord
    has_many :db_threads
    validates_associated :db_threads

    validates :board, :title, :meta_description, presence: true
    validates :board, uniqueness: true

    def get_anchor
        "<a href=\"/posts/?board=#{board}\">#{board}</a>"
    end

    def self.get_boards_with_posts
        DbBoard.all.select { |b| b.db_threads.size > 0 }
    end
end
