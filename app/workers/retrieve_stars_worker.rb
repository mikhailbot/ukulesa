class RetrieveStarsWorker
  include Sidekiq::Worker

  def perform(user_id = nil)
    user = User.find_by_id(user_id)

    if user
      GithubApiService.new(user.oauth_token).retrieve_starred_repositories(user)
    else
      GithubApiService.new(ENV['GITHUB_ACCESS_TOKEN']).retrieve_starred_repositories
    end
  end
end
