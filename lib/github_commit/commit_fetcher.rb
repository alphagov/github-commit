module GithubCommit
  class CommitFetcher
    def initialize(repo:, client: Octokit::Client.new)
      @client = client
      @repo = repo
    end

    def fetch_commit(sha:)
      client.commit(repo, sha)
    end

    def fetch_status(sha:)
      client.status(repo, sha)
    end

  private

    attr_reader :client, :repo
  end
end
