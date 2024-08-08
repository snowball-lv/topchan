class DbReference < ApplicationRecord
  belongs_to :post, class_name: "DbPost"
  belongs_to :ref, class_name: "DbPost"
end
