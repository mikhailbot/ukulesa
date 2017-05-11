class GithubApiService
  def initialize(auth_token)
    @github = Github.new oauth_token: auth_token, auto_pagination: true
  end

  def retrieve_starred_repositories
    @github.activity.starring.starred
  end
end
