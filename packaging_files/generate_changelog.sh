#!/bin/bash
# Generate debian/changelog with correct version for this build.
#
# Run from inside the source directory (e.g. ollama-0.33.3/).
# Expects packaging_files/changelog at ../packaging_files/changelog.
#
# This script:
#   1. Reads the current history from packaging_files/changelog
#   2. Prepends a new entry for the current version
#   3. Writes the updated history back to packaging_files/changelog
#   4. Copies the result to debian/changelog for the build
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
BUILD_CHANGELOG="debian/changelog"

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
echo "============================"

# Build the new entry
NEW_ENTRY=$(cat <<EOF
ollama (${VERSION}) ${DISTRIBUTION}; urgency=medium

  * ${ENTRY_BODY}

 -- ${MAINTAINER}  ${DATE}
EOF
)

# Prepend new entry to history file (history is append-only, never overwritten)
# Use a temp file to avoid "input file is output file" error
TEMP_FILE=$(mktemp)
{
  echo "${NEW_ENTRY}"
  echo ""
  if [ -f "$HISTORY_FILE" ]; then
    cat "$HISTORY_FILE"
  fi
} > "${TEMP_FILE}"
mv "${TEMP_FILE}" "${HISTORY_FILE}"

# Copy updated history to build directory
cp "${HISTORY_FILE}" "${BUILD_CHANGELOG}"

echo "Prepended entry for ${VERSION} to ${HISTORY_FILE} ($((HISTORY_COUNT + 1)) total entries)"
echo "Generated ${BUILD_CHANGELOG}"
