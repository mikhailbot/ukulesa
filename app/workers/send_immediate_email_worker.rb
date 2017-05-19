class SendImmediateEmailWorker
  include Sidekiq::Worker

  def perform(issue_id = nil)
    issue = issue.find_by_id(issue_id)

    if issue
      SimpleSpark.new().send_immediate_notification(new_issue)
    end
  end
end
