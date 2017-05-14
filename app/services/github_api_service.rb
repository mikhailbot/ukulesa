class GithubApiService
  def initialize(auth_token)
    @github = Github.new oauth_token: auth_token, auto_pagination: true
  end

  def retrieve_starred_repositories
    @github.activity.starring.starred
  end

  def retrieve_new_closed_issues(user, repo, time)
    @github.issues.list user: user, repo: repo, state: 'closed', since: time.to_formatted_s(:iso8601)
  end
end
