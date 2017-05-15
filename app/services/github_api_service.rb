class GithubApiService
  def initialize(auth_token)
    @github = Github.new oauth_token: auth_token, auto_pagination: true
  end

  def retrieve_starred_repositories(user = nil)
    if user
      user_starred_repos(user)
    else
      User.find_each do |user|
        user_starred_repos(user)
      end
    end
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

  private

  def user_starred_repos(user)
    starred_repos = @github.activity.starring.starred user: user.username
    starred_repos.each do |starred_repo|
      if (starred_repo.name.downcase == 'ama')
        @repo = Repo.find_or_create_by(full_name: starred_repo.full_name) do |repo|
          repo.name = starred_repo.name
          repo.full_name = starred_repo.full_name
          repo.owner_name = starred_repo.owner.login
          repo.owner_id = starred_repo.owner.id
          repo.avatar_url = starred_repo.owner.avatar_url
          repo.last_checked = Time.now
          repo.save!
        end
        begin
          user.repos << @repo
        rescue ActiveRecord::RecordInvalid
          puts "Repo #{@repo.full_name} already exists for #{user.username}"
        end
      end
    end unless starred_repos.nil?
  end
end
