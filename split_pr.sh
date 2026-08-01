#!/bin/bash
set -e

echo "Starting PR split process..."

# Ensure we have the latest from upstream
git fetch upstream main

# Keep the current branch as backup
git branch backup-feat-invitation-part-6 || echo "Backup branch already exists"

# 1. Branch for Registration Fixes & Compose Edits
echo "Creating fix/registration-and-compose branch..."
git checkout -B fix/registration-and-compose upstream/main
git checkout feat/channel-invitation-workflow-part-6 -- Makefile bootup/docker-compose-files/docker-compose.dev.yml src/dashboard/yarn.lock src/dashboard/package.json src/dashboard/config/config.js src/dashboard/src/components/Login/index.js src/dashboard/src/components/Login/map.js src/dashboard/src/models/login.js src/dashboard/src/pages/User/Login.js src/dashboard/src/utils/request.js || true
if ! git diff --cached --quiet || ! git diff --quiet; then
  git add .
  git commit -m "fix: registration workflow and docker compose setup"
fi

# 2. Branch for CI, Lockfile, and Docs
echo "Creating chore/docs-and-ci branch..."
git checkout -B chore/docs-and-ci upstream/main
git checkout feat/channel-invitation-workflow-part-6 -- .github/workflows/lint-check.yml docs/reference/configuration/server.md docs/setup/server.md docs/tutorials/agent.md docs/tutorials/server.md src/dashboard/src/locales/en-US/Overview.js src/dashboard/src/locales/zh-CN/Overview.js src/dashboard/src/pages/Overview/index.js || true
if ! git diff --cached --quiet || ! git diff --quiet; then
  git add .
  git commit -m "chore: update documentation and CI linting"
fi

# 3. Branch for Backend + Agent
echo "Creating feat/channel-invitation-backend branch..."
git checkout -B feat/channel-invitation-backend upstream/main
git checkout feat/channel-invitation-workflow-part-6 -- src/agents/ src/api-engine/ || true
if ! git diff --cached --quiet || ! git diff --quiet; then
  git add .
  git commit -m "feat: add channel invitation backend and agent logic"
fi

# 4. Branch for Dashboard UI
echo "Creating feat/channel-invitation-ui branch..."
git checkout -B feat/channel-invitation-ui upstream/main
git checkout feat/channel-invitation-workflow-part-6 -- src/dashboard/config/router.config.js src/dashboard/jest.config.js src/dashboard/src/__tests__/models/invitation.test.js src/dashboard/src/__tests__/pages/Channel/Invitation.test.js src/dashboard/src/__tests__/services/invitation.test.js src/dashboard/src/locales/en-US/Channel.js src/dashboard/src/locales/zh-CN/Channel.js src/dashboard/src/models/channel.js src/dashboard/src/models/invitation.js src/dashboard/src/pages/ChainCode/forms/UploadForm.js src/dashboard/src/pages/Channel/Channel.js src/dashboard/src/pages/Channel/Invitation.js src/dashboard/src/pages/Channel/forms/CreateInvitationForm.js src/dashboard/src/pages/Organization/Organization.js src/dashboard/src/services/invitation.js src/dashboard/src/utils/modelFactory.js || true
if ! git diff --cached --quiet || ! git diff --quiet; then
  git add .
  git commit -m "feat: add channel invitation UI"
fi

# Return to main
git checkout main
echo "Done! The PR has been split into four new branches."
echo "You can now push these branches and open 4 separate PRs:"
echo "git push origin fix/registration-and-compose"
echo "git push origin chore/docs-and-ci"
echo "git push origin feat/channel-invitation-backend"
echo "git push origin feat/channel-invitation-ui"
