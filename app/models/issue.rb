class Issue < ApplicationRecord
  belongs_to :repo, optional: true

  validates :number, uniqueness: { :scope => :repo_id }
end
