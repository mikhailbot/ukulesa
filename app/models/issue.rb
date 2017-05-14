class Issue < ApplicationRecord
  belongs_to :repos, optional: true
end
