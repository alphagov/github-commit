module GithubCommit
  class CommitWriter
    def initialize(commit:, status:, dir:)
      @commit = commit
      @status = status
      @dir = dir
    end

    def write_commit!
      File.open("#{dir}/ref", "w") { |f| f.write commit.sha }
      File.open("#{dir}/state", "w") { |f| f.write status.state }
      File.open("#{dir}/combined_status", "w") { |f| f.write status.to_h.to_json }
      File.open("#{dir}/commit", "w") { |f| f.write commit.to_h.to_json }
      File.open("#{dir}/author", "w") { |f| f.write commit.commit.author.name }
      File.open("#{dir}/message", "w") { |f| f.write commit.commit.message }
    end

    def metadata
      {
        version: { ref: commit.sha },
        metadata: [
          { name: "author", value: commit.commit.author.name },
          { name: "message", value: commit.commit.message },
          { name: "status", value: status.state },
          { name: "commit", value: commit.sha },
        ],
      }
    end

  private

    attr_reader :commit, :status, :dir
  end
end
