require "github_commit/status_updater"

describe GithubCommit::StatusUpdater do
  it "can be initialized" do
    expect { described_class.new(client: nil, repo: nil, sha: nil) }.not_to raise_error
  end

  describe "#update_status" do
    subject(:updater) { described_class.new(client: client, repo: repo, sha: sha) }

    let(:client) { instance_double("Octokit::Client") }
    let(:repo) { "alphagov/example" }
    let(:sha) { "123" }
    let(:title) { "Concourse" }
    let(:target_url) { "https://example.org" }
    let(:description) { "The Concourse pipeline is running..." }
    let(:status) { "pending" }

    it "updates the status for a commit" do
      expect(client).to receive(:create_status).with(
        repo,
        sha,
        status,
        {
          context: title,
          target_url: target_url,
          description: description,
        },
      )

      updater.update_status(
        status: status,
        context: title,
        target_url: target_url,
        description: description,
      )
    end
  end
end
