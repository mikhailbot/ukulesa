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

  def retrieve_new_closed_issues
    Repo.find_each do |repo|
      repo_closed_issues(repo)
    end
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

  def repo_closed_issues(repo)
    last_checked = repo.last_checked.to_formatted_s(:iso8601)
    issues = @github.issues.list user: repo.owner_name, repo: repo.name, state: 'closed', since: last_checked

    issues.each do |issue|
      if issue.closed_at >= last_checked
        begin
          new_issue = Issue.create(:repo_id => repo.id,
          :number => issue.number,
          :title => issue.title,
          :link => issue.html_url,
          :closed_at => DateTime.parse(issue.closed_at))

          question = issue.body
          html_question = convert_to_html(question)

          answer = retrieve_ama_answer(repo.owner_name, repo.name, issue.number)
          html_answer = convert_to_html(answer)
          
          new_issue.update({ :answer => html_answer, :question => html_question })

          new_issue.save!
          SendImmediateEmailWorker.perform_async(new_issue.id)
        rescue ActiveRecord::RecordInvalid
          puts "Issue #{issue.number} already exists for #{repo.full_name}"
        end
      end
    end unless issues.nil?

    repo.update(last_checked: Time.now)
    repo.save!
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

  def convert_to_html(string=nil)
    unless string.nil?
      renderer = Redcarpet::Render::HTML.new()
      markdown = Redcarpet::Markdown.new(renderer, extensions = {})
      markdown.render(string)
    else
      nil
    end
  end
end
