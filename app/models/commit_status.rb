class CommitStatus
  def initialize(repo_name:, sha:, github:)
    @repo_name = repo_name
    @sha = sha
    @github = github
  end

  def set_pending
    github.create_pending_status(repo_name, sha, I18n.t(:pending_status))
  end

  def set_success(violation_count)
    message = I18n.t(:success_status, count: violation_count)
    github.create_success_status(repo_name, sha, message)
  end

  def set_failure
    message = I18n.t(:config_error_status)
    github.create_error_status(repo_name, sha, message, configuration_url)
  end

  private

  attr_reader :repo_name, :sha, :github

  def configuration_url
    Rails.application.routes.url_helpers.configuration_url(host: ENV["HOST"])
  end
end
