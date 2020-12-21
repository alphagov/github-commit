# Concourse GitHub Commit Resource

A Concourse resource type for GitHub commits.

The `check` script detects new commits on *any* branch on a GitHub repository.
This includes commits for work-in-progress branches, but does not include commits
on any other GitHub repository, such as forks.

The `in` script (used in `get` steps) creates several files corresponding to a
single commit on any branch of a GitHub repository:

* `ref` contains the sha of the commit
* `author` contains the name of the committer from GitHub's API
* `message` contains the commit message from GitHub's API
* `state` contains the current combined status of the commit, if any
* `repo` contains the pulled repository checked out at the specified commit
* `combined_status` contains the full `combined_status` JSON from GitHub's API
* `commit` contains the full `commit` JSON from GitHub's API

These files should be sufficient to replace some workflows for the popular
[git resource](https://github.com/concourse/git-resource) provided by Concourse.

The `out` script (used in `put` steps) allows one to add a status to a commit
in GitHub. For example, you might add a "pending" status at the beginning of
a build or test run and add a "success" step at the end of the build.

## Usage

The following example runs tests for every new commit, and updates the status
for a check on a GitHub commit (pending, and then success/failure/error).

```yaml
resource_types:
  - name: github-commit
    type: registry-image
    source:
      repository: govuk/github-commit

resources:
  - name: commit
    type: github-commit
    source:
      repository: alphagov/frontend
      access_token: ((github_access_token))
      path: commit # relative path to the commit, must match the resource name.

jobs:
  - name: run-tests
    plan:
    - get: github-commit
      trigger: true
    - put: github-commit
      params:
        context: run-tests # corresponds to GitHub Status API context field
        status: pending # puts a pending status on the GitHub commit
    - task: run-tests
      file: repo/run-tests.yml
    on_success:
      put: commit
      params: {status: success, context: run-tests} # puts a success status on the GitHub commit
    on_failure:
      put: commit
      params: {status: failure, context: run-tests}
    on_abort:
      put: commit
      params: {status: error, context: run-tests}
    on_error:
      put: commit
      params: {status: error, context: run-tests}
```

## Development

The output of this project is a container image pushed to DockerHub, for use
in Concourse pipelines as a Resource Type.

Read [Implementing a Resource Type](https://concourse-ci.org/implementing-resource-types.html)
for an understanding of how this project fits into a Concourse pipeline.

### Run tests

Tests for this project run in [GitHub Actions](https://github.com/alphagov/github-commit/actions),
but can also be run locally:

```
bundle exec rubocop
bundle exec rspec
```

### Publish

Concourse pipelines pull the resource type as a Docker image; we also publish
the `lib` part of the project as a gem.

- DockerHub: https://hub.docker.com/r/govuk/github-commit
- RubyGems: https://rubygems.org/gems/github_commit
