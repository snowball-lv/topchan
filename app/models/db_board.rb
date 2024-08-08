class DbBoard < ApplicationRecord
    has_many :db_threads
    validates_associated :db_threads

    validates :board, :title, :meta_description, presence: true
    validates :board, uniqueness: true

    def get_anchor
        "<a href=\"/posts/?board=#{board}\">#{board}</a>"
    end
end
