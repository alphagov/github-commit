module GithubCommit
  class StatusUpdater
    def initialize(repo:, sha:, client: Octokit::Client.new)
      @client = client
      @repo = repo
      @sha = sha
    end

    def update_status(status:, context: nil, target_url: nil, description: nil)
      options = {
        context: context,
        target_url: target_url,
        description: description,
      }.compact

      client.create_status(repo, sha, status, options)
    end

  private

    attr_reader :client, :repo, :sha
  end
end
