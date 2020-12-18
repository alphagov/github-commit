module GithubCommit
  class CommitsFetcher
    def initialize(repo:, client: Octokit::Client.new)
      @client = client
      @repo = repo
    end

    def commits(sha: nil)
      branch_commits = client.branches(repo).map do |branch|
        client.commits(repo, { sha: branch.commit.sha, per_page: 15 })
          .map do |c|
            {
              date: c.commit.committer.date,
              sha: c.sha,
            }
          end
      end

      commits = branch_commits.flatten
        .uniq { |c| c.dig(:sha) }
        .sort { |a, b| b.dig(:date) <=> a.dig(:date) }
        .map { |s| { ref: s.dig(:sha) } }

      return [commits.first] unless sha

      index = commits.index({ ref: sha })
      index = 1 if index == commits.count - 1
      output = commits[0..index]

      output.reverse
    end

  private

    attr_reader :client, :repo, :sha
  end
end
