class PagesController < ApplicationController
  def index
    @repos = User.find(current_user.id).repos
  end
end
