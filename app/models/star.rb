class Star < ApplicationRecord
  belongs_to :user
  belongs_to :repo

  validates :repo_id, uniqueness: { :scope => :user_id }
end
