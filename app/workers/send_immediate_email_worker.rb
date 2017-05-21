class SendImmediateEmailWorker
  include Sidekiq::Worker

  def perform(issue_id = nil)
    issue = Issue.find_by_id(issue_id)

    if issue
      SparkPostService.new().send_immediate_notification(issue)
    end
  end
end
