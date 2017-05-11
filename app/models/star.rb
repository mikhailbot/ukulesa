class Stars < ApplicationRecord
  belongs_to :users
  belongs_to :repos
end
