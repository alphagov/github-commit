# Concourse GitHub Commit Resource

A Concourse resource type for GitHub commits.

The `in` step creates a directory `.github` containing several files:

* `ref` contains the sha of the commit
* `author` contains the name of the committer from GitHub's API
* `message` contains the commit message from GitHub's API
* `state` contains the current combined status of the commit, if any
* `repo` contains the pulled repository checked out at the specified commit
* `combined_status` contains the full `combined_status` JSON from GitHub's API
* `commit` contains the full `commit` JSON from GitHub's API

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

## `get`

Options:

```
collaborators_only: Only `verified` commits from collaborators
```

## Development

The output of this project is a container image pushed to DockerHub, for use
in Concourse pipelines as a Resource Type.
