class PagesController < ApplicationController
  def index
    if (current_user)
      user = User.find(current_user.id)
      @repos = user.repos
      @user_avatar = user.avatar_url
    end
  end
end
