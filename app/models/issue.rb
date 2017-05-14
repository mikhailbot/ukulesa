class Issue < ApplicationRecord
  belongs_to :repos, optional: true

  validates :number, uniqueness: { :scope => :repo_id }
end
