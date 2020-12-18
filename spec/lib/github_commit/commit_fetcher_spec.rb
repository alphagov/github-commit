require "github_commit/commit_fetcher"

describe GithubCommit::CommitFetcher do
  it "can be initialized" do
    expect { described_class.new(client: nil, repo: nil) }.not_to raise_error
  end

  context "with authorized client" do
    subject(:fetcher) { described_class.new(client: client, repo: repo) }

    let(:repo) { "alphagov/example" }
    let(:sha) { "123" }
    let(:client) { instance_double("Octokit::Client") }

    describe "#fetch_commit" do
      let(:commit) { { sha: sha } }

      it "fetches a commit" do
        expect(client).to receive(:commit).with(repo, sha).and_return(commit)
        expect(fetcher.fetch_commit(sha: sha)).to eq(commit)
      end
    end

    describe "#fetch_status" do
      let(:status) { { sha: sha, state: "success" } }

      it "fetches a status for a commit" do
        expect(client).to receive(:status).with(repo, sha).and_return(status)
        expect(fetcher.fetch_status(sha: sha)).to eq(status)
      end
    end
  end
end
