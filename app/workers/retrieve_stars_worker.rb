class RetrieveStarsWorker
  include Sidekiq::Worker

  def perform(user_id = nil)
    user = User.find_by_id(user_id)

    if user
      GithubApiService.new(user.oauth_token).retrieve_starred_repositories(user)
      SparkPostService.new().send_welcome_email(user_id)
    else
      GithubApiService.new(ENV['GITHUB_ACCESS_TOKEN']).retrieve_starred_repositories
    end
  end
end
