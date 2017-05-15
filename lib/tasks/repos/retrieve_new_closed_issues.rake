namespace :repos do
  desc 'Retrieves New Closed Issues for All Repos'
  task retrieve_new_closed_issues: :environment do
    log = ActiveSupport::Logger.new('log/retrieve_new_closed_issues.log')
    start_time = Time.now
    log.info "Task started at #{start_time}"

    @github = GithubApiService.new(ENV['GITHUB_ACCESS_TOKEN'])

    Repo.find_each do |repo|
      issues = @github.retrieve_new_closed_issues(repo.owner_name, repo.name, repo.last_checked)

      issues.each do |issue|
        begin
          new_issue = Issue.create(:repo_id => repo.id,
            :number => issue.number,
            :title => issue.title,
            :link => issue.html_url,
            :closed_at => DateTime.parse(issue.closed_at))

          answer = @github.retrieve_ama_answer(repo.owner_name, repo.name, issue.number)
          new_issue.update(answer: answer)

          new_issue.save!
          log.info "Added new issue #{issue.number} for #{repo.full_name}"
        rescue ActiveRecord::RecordInvalid
          log.info "Issue #{issue.number} already exists for #{repo.full_name}"
        end
      end unless issues.nil?

      repo.update(last_checked: Time.now)
      repo.save!
    end

    end_time = Time.now
    duration = (start_time - end_time) / 1.minute
    log.info "Task finished at #{end_time} and lasted #{duration} minutes."
    log.close
  end
end
