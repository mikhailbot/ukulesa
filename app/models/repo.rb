class Repo < ApplicationRecord
  has_many :stars
  has_many :issues
  has_many :users, :through => :stars
end
