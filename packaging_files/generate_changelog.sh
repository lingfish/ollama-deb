#!/bin/bash
# Generate debian/changelog with correct version for this build.
#
# Run from inside the source directory (e.g. ollama-0.33.3/).
# Expects packaging_files/changelog at ../packaging_files/changelog.
#
# Usage: ../packaging_files/generate_changelog.sh <version>
#   version: Debian package version (e.g. 0.33.3 or 0.33.3~rc1)

set -euo pipefail

VERSION="${1:?Usage: generate_changelog.sh <version>}"
MAINTAINER="lingfish <lingfish@users.noreply.github.com>"
DATE=$(date -R)

# Determine distribution from version
if echo "$VERSION" | grep -q '~rc'; then
  DISTRIBUTION="unstable"
else
  DISTRIBUTION="stable"
fi

HISTORY_FILE="../packaging_files/changelog"

# Build the new entry
{
  echo "ollama (${VERSION}) ${DISTRIBUTION}; urgency=medium"
  echo ""
  echo "  * New upstream release"
  echo ""
  echo " -- ${MAINTAINER}  ${DATE}"
  echo ""
  # Append past entries from the history file
  if [ -f "$HISTORY_FILE" ]; then
    cat "$HISTORY_FILE"
  fi
} > "debian/changelog"
