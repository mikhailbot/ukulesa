class PagesController < ApplicationController
  def index
    set_meta_tags title: 'GitHub AMA Email Notifications',
      description: 'Get an email when a GitHub AMA question gets answered.',
      keywords: 'GitHub, AMA, Email, Notifications',
      og: {
        title: 'Ukulesa',
        type: 'website',
        url: 'http://ukulesa.com',
        image: ActionController::Base.helpers.asset_path('/images/logo.png'),
        description: 'Get an email when a GitHub AMA question gets answered.'
      },
      twitter: {
        title: 'Ukulesa',
        card: 'summary',
        site: '@amaukulesa',
        image: ActionController::Base.helpers.asset_path('/images/logo.png'),
        description: 'Get an email when a GitHub AMA question gets answered.'
      }

    unless current_user.nil?
      redirect_to '/profile'
    end
  end
end
