require "github_commit/commit_writer"
require "tmpdir"

describe GithubCommit::CommitWriter do
  attr_reader :temp_dir

  around do |example|
    dir = Dir.mktmpdir
    begin
      @temp_dir = dir
      example.run
    ensure
      FileUtils.remove_entry dir
    end
  end

  # rubocop:disable RSpec/VerifiedDoubles
  let(:status) do
    double("Sawyer::Resource",
           state: commit_state,
           to_h: { state: commit_state })
  end
  let(:commit) do
    double("Sawyer::Resource",
           sha: sha,
           to_h: { sha: sha },
           commit: double("Sawyer::Resource",
                          author: double("Sawyer::Resource",
                                         name: commit_author),
                          message: commit_msg))
  end
  # rubocop:enable RSpec/VerifiedDoubles
  let(:commit_state) { "pending" }
  let(:commit_msg) { "Add tests" }
  let(:commit_author) { "Harry Potter" }
  let(:sha) { "123" }

  it "can be initialized" do
    expect { described_class.new(commit: nil, status: nil, dir: nil) }.not_to raise_error
  end

  describe "#write_commit!" do
    subject(:writer) { described_class.new(commit: commit, status: status, dir: dir) }

    let(:dir) { temp_dir }

    it "writes out files to the directory" do
      expect(Dir.exist?(temp_dir)).to be true
      writer.write_commit!
      expect(File.read("#{dir}/ref")).to eq(sha)
      expect(File.read("#{dir}/state")).to eq(commit_state)
      expect(File.read("#{dir}/combined_status")).to eq("{\"state\":\"pending\"}")
      expect(File.read("#{dir}/commit")).to eq("{\"sha\":\"123\"}")
      expect(File.read("#{dir}/author")).to eq(commit_author)
      expect(File.read("#{dir}/message")).to eq(commit_msg)
    end
  end

  describe "#metadata" do
    subject(:writer) { described_class.new(commit: commit, status: status, dir: "dir") }

    it "returns a hash" do
      expect(writer.metadata).to eq({
        version: { ref: sha },
        metadata: [
          { name: "author", value: commit_author },
          { name: "message", value: commit_msg },
          { name: "status", value: commit_state },
          { name: "commit", value: sha },
        ],
      })
    end
  end
end
