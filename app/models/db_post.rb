class DbPost < ApplicationRecord
  belongs_to :db_thread

  validates :no, :json, presence: true

  # has_many :db_references
  # has_many :replies, through: :db_references, source: :ref
  # has_many :refs, through: :db_references, source: :ref


  def get_thread_no
    return db_thread.no
  end

  def get_board_code
    return db_thread.db_board.board
  end

  def get_com
    return JSON.parse(json)["com"]
  end

  def get_path
    return "/#{get_board_code}/#{no}"
  end

  def get_db_refs
    return DbReference.where(post: self).map { |r| r.ref.no }
  end

  def get_db_replies
    return DbReference.where(ref: self).map { |r| r.post.no }
  end

  def get_refs
    com = get_com
    return [] if com.nil?
    doc = Nokogiri::HTML(com)
    links = doc.css("a.quotelink")
    return links.map { |link|
      link["href"].scan(/^#p(\d+)$/).first
    }.compact.flatten
  end

end
