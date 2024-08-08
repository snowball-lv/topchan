class DbBoard < ApplicationRecord
    has_many :db_threads
    validates_associated :db_threads

    validates :board, :title, :meta_description, presence: true
    validates :board, uniqueness: true
end
