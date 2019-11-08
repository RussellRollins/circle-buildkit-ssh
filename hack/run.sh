#! /usr/bin/env bash
set -euo pipefail

# The build / run process isn't quite as simple now, so script it for
# convenience sake.
docker build \
  --tag doer \
  --ssh default \
  --secret id=ssh.config,src="${HOME}/.ssh/config" \
  .
docker run doer
