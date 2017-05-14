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

  def retrieve_ama_answer(user, repo, issue)
    answer = nil
    comments = @github.issues.comments.all user: user, repo: repo, number: issue

    comments.each do |comment|
      if comment.user.login == user
        answer = comment.body
        break
      end
    end unless comments.nil?

    answer
  end
end
