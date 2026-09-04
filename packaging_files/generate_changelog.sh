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

# Determine entry type based on repack suffix
if echo "$VERSION" | grep -q '+repack'; then
  ENTRY_BODY="Repack for packaging updates"
else
  ENTRY_BODY="New upstream release"
fi

HISTORY_FILE="../packaging_files/changelog"
OUTPUT_FILE="debian/changelog"

# Count history entries
HISTORY_COUNT=0
if [ -f "$HISTORY_FILE" ]; then
  HISTORY_COUNT=$(grep -c '^ollama (' "$HISTORY_FILE" || true)
fi

echo "=== generate_changelog.sh ==="
echo "Version:      ${VERSION}"
echo "Distribution: ${DISTRIBUTION}"
echo "Entry type:   ${ENTRY_BODY}"
echo "Date:         ${DATE}"
echo "History file: ${HISTORY_FILE} (${HISTORY_COUNT} entries)"
echo "Output:       ${OUTPUT_FILE}"
echo "============================"

# Build the new entry
{
  echo "ollama (${VERSION}) ${DISTRIBUTION}; urgency=medium"
  echo ""
  echo "  * ${ENTRY_BODY}"
  echo ""
  echo " -- ${MAINTAINER}  ${DATE}"
  echo ""
  # Append past entries from the history file
  if [ -f "$HISTORY_FILE" ]; then
    cat "$HISTORY_FILE"
  fi
} > "${OUTPUT_FILE}"

echo "Generated ${OUTPUT_FILE} with $((HISTORY_COUNT + 1)) total entries"
