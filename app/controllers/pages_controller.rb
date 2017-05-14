class PagesController < ApplicationController
  def index
    if (current_user)
      @repos = User.find(current_user.id).repos
    end
  end
end
