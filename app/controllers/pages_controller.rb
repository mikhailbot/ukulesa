class PagesController < ApplicationController
  def index
    unless current_user.nil?
      redirect_to '/profile'
    end
  end
end
