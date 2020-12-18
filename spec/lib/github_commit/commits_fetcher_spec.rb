require "github_commit/commits_fetcher"

describe GithubCommit::CommitsFetcher do
  it "can be initialized" do
    expect { described_class.new(client: nil, repo: nil) }.not_to raise_error
  end

  context "with authorized client" do
    let(:fetcher) { described_class.new(client: client, repo: repo) }

    let(:repo) { "alphagov/example" }
    let(:sha1) { "123" }
    let(:sha2) { "456" }
    let(:sha3) { "789" }

    let(:client) { instance_double("Octokit::Client") }

    describe "#commits" do
      let(:commit1) do
        # rubocop:disable RSpec/VerifiedDoubles
        double("Sawyer::Resource",
               sha: sha1,
               commit: double("Sawyer::Resource",
                              committer: double("Sawyer::Resource", date: Time.parse("2018-12-25"))))
      end
      let(:commit2) do
        double("Sawyer::Resource",
               sha: sha2,
               commit: double("Sawyer::Resource",
                              committer: double("Sawyer::Resource", date: Time.parse("2020-12-25"))))
      end
      let(:commit3) do
        double("Sawyer::Resource",
               sha: sha3,
               commit: double("Sawyer::Resource",
                              committer: double("Sawyer::Resource", date: Time.parse("2019-12-25"))))
      end
      let(:branches) do
        [
          double("Sawyer::Resource",
                 commit: double("Sawyer::Resource",
                                sha: sha1)),
          double("Sawyer::Resource",
                 commit: double("Sawyer::Resource",
                                sha: sha2)),
          double("Sawyer::Resource",
                 commit: double("Sawyer::Resource",
                                sha: sha3)),
          # rubocop:enable RSpec/VerifiedDoubles
        ]
      end

      context "when a commit hash is provided" do
        it "fetches the succeeding commits in reverse chronological order" do
          expect_calls
          expect(fetcher.commits(sha: sha1)).to eq([{ ref: sha3 }, { ref: sha2 }])
        end
      end

      context "when a commit hash is not provided" do
        it "returns the most recent commit" do
          expect_calls
          expect(fetcher.commits).to eq([{ ref: sha2 }])
        end
      end

      def expect_calls
        expect(client).to receive(:branches).with(repo).and_return(branches)
        expect(client).to receive(:commits).with(repo, { sha: sha1, per_page: 15 }).and_return([commit1])
        expect(client).to receive(:commits).with(repo, { sha: sha2, per_page: 15 }).and_return([commit2])
        expect(client).to receive(:commits).with(repo, { sha: sha3, per_page: 15 }).and_return([commit3])
      end
    end
  end
end
