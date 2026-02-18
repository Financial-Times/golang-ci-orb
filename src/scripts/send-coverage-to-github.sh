#!/bin/bash

# Extract total coverage from a coverage report
cov() {
  go tool cover -func="$1" | awk '/^total:/ {print $3}'
}

coverage_report="${COVERAGE_REPORT_FOLDER}/coverage.out"
coverage_main_report="${COVERAGE_REPORT_FOLDER}/coverage-main.out"
coverage="$(cov "$coverage_report")"


# Determine the default branch (main or master)
current_branch=$(git rev-parse --abbrev-ref HEAD)
default_branch="main"
if git show-ref --verify --quiet refs/heads/master; then
  default_branch="master"
fi

# Check if the circleci job is running on the default branch, if so just report the coverage
if [ "$current_branch" = "$default_branch" ]; then
  # On default branch, just report current coverage
  msg="Coverage on $default_branch is $coverage"
  status_state="success"
else
  # Fetch and checkout default branch
  git fetch origin "$default_branch":"$default_branch"
  git checkout "$default_branch"
  go test -coverprofile="$coverage_main_report" ./...
  coverage_main="$(cov "$coverage_main_report")"
  git checkout -

  # Calculate difference
  coverage_num="${coverage//%/}"
  coverage_main_num="${coverage_main//%/}"
  # Use awk for floating-point subtraction
  diff=$(awk "BEGIN {print $coverage_num - $coverage_main_num}")

  # Format message and status
  # Set default message and status
  diff_fmt=$(awk "BEGIN {printf \"%.2f\", $diff}")
  msg="Coverage remained the same at $coverage"
  status_state="success"
  if awk "BEGIN {exit !($diff > 0)}"; then
    msg="Coverage increased (+$diff_fmt%) to $coverage"
  elif awk "BEGIN {exit !($diff < 0)}"; then
    diff_abs="${diff_fmt#-}"
    msg="Coverage decreased (-$diff_abs%) to $coverage"
    status_state="failure"
  fi
fi

# Always post custom status to GitHub using GitHub CLI, suppress output unless there is an error
if ! gh api repos/"$CIRCLE_PROJECT_USERNAME"/"$CIRCLE_PROJECT_REPONAME"/statuses/"$CIRCLE_SHA1" \
  --method POST \
  -f state="$status_state" \
  -f target_url="https://circleci.com/gh/$CIRCLE_PROJECT_USERNAME/$CIRCLE_PROJECT_REPONAME/$CIRCLE_BUILD_NUM" \
  -f description="$msg" \
  -f context="coverage/go" > /dev/null
then
  echo "gh api status check creation failed:" >&2
fi

echo "$msg"
