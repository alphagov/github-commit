require_relative "./github_commit/commit_fetcher"
require_relative "./github_commit/commits_fetcher"
require_relative "./github_commit/commit_writer"
require_relative "./github_commit/status_updater"

module GithubCommit
  VERSION = File.read(File.join(File.dirname(__FILE__), "../VERSION")).chomp.freeze
end
