#!/usr/bin/env bash
# Generates a CONTENTS.md file with release and .deb package information

set -euo pipefail

OUTPUT="CONTENTS.md"
RELEASE_NAME="${GITHUB_REF_NAME:-unknown}"

# Header
{
  echo "# Package information"
  echo "This is release ${RELEASE_NAME}."
  echo
  echo "## deb info"
} > "$OUTPUT"

# Per-package dpkg -I info
for f in *.deb; do
  {
    echo "### $f"
    echo '```'
    dpkg -I "$f"
    echo '```'
  } >> "$OUTPUT"
done

# This is disabled due to the GitHub API rejecting large payloads
# Per-package file listing
#echo "## deb file contents:" >> "$OUTPUT"
#for f in *.deb; do
#  {
#    echo "### $f"
#    echo '```'
#    dpkg -c "$f"
#    echo '```'
#  } >> "$OUTPUT"
#done

# upstream release notes
echo "# Upstream release notes" >> "$OUTPUT"
gh release view ${RELEASE_NAME} --repo https://github.com/ollama/ollama --json body --jq .body >> "$OUTPUT"
