#!/bin/bash

coverage=$(go tool cover -func="${COVERAGE_REPORT_FOLDER}/coverage.out" | grep total: | awk '{print $3}')
# Fetch and checkout main branch
git fetch origin main:main
git checkout main
go test -coverprofile="${COVERAGE_REPORT_FOLDER}/coverage-main.out" ./...
coverage_main=$(go tool cover -func="${COVERAGE_REPORT_FOLDER}/coverage-main.out" | grep total: | awk '{print $3}')
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

# Always post custom status to GitHub
curl -L \
  -X POST \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer $GITHUB_TOKEN" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  -H "Content-Type: application/json" \
  "https://api.github.com/repos/$CIRCLE_PROJECT_USERNAME/$CIRCLE_PROJECT_REPONAME/statuses/$CIRCLE_SHA1" \
  -d "{\"state\":\"$status_state\",\"target_url\":\"https://circleci.com/gh/$CIRCLE_PROJECT_USERNAME/$CIRCLE_PROJECT_REPONAME/$CIRCLE_BUILD_NUM\",\"description\":\"$msg\",\"context\":\"coverage/go\"}"

# Get PR number using grep/awk
pr_response=$(curl --location --request GET "https://api.github.com/repos/$CIRCLE_PROJECT_USERNAME/$CIRCLE_PROJECT_REPONAME/pulls?head=$CIRCLE_PROJECT_USERNAME:$CIRCLE_BRANCH&state=open" \
  -u "$GITHUB_USERNAME:$GITHUB_TOKEN")
pr_number=$(echo "$pr_response" | awk '/"number":/ {print $2; exit}')

# Only post PR comment if there is an open PR for this branch
if [ -n "$pr_number" ]; then
  comments=$(curl --location --request GET "https://api.github.com/repos/$CIRCLE_PROJECT_USERNAME/$CIRCLE_PROJECT_REPONAME/issues/$pr_number/comments" \
    -u "$GITHUB_USERNAME:$GITHUB_TOKEN")
  # Find comment id for coverage comment
  comment_id=$(echo "$comments" | awk '
    /"user":/ {in_user=1}
    /^[[:space:]]*}/ {in_user=0}
    /^[[:space:]]*"id":/ && !in_user {id=$2}
    /"body": "Coverage/ {gsub(/,/, "", id); print id; exit}
  ')
  body="$msg"
  if [ -n "$comment_id" ]; then
    # Update existing comment
    curl --location --request PATCH "https://api.github.com/repos/$CIRCLE_PROJECT_USERNAME/$CIRCLE_PROJECT_REPONAME/issues/comments/$comment_id" \
      -u "$GITHUB_USERNAME:$GITHUB_TOKEN" \
      --header 'Content-Type: application/json' \
      --data-raw "{\"body\": \"$body\"}"
  else
    # Create new comment
    curl --location --request POST "https://api.github.com/repos/$CIRCLE_PROJECT_USERNAME/$CIRCLE_PROJECT_REPONAME/issues/$pr_number/comments" \
      -u "$GITHUB_USERNAME:$GITHUB_TOKEN" \
      --header 'Content-Type: application/json' \
      --data-raw "{\"body\": \"$body\"}"
  fi
else
  echo "No open pull request found for this branch. No PR comment will be posted."
fi
