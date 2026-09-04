# Agent Maintenance Guide

This file documents what agents need to know to maintain the Debian packaging
changelog, NEWS, and README files.

## Files overview

| File | Location | Installed as | Maintained by |
|------|----------|-------------|---------------|
| `changelog` | `packaging_files/changelog` | `changelog.Debian.gz` | CI (auto-commits after each build) |
| `generate_changelog.sh` | `packaging_files/generate_changelog.sh` | — | CI (generates current entry at build time) |
| `NEWS` | `packaging_files/NEWS` | `NEWS.Debian.gz` | Agent (significant changes only) |
| `README.Debian` | `packaging_files/README.Debian` | `README.Debian` | Agent (when structure changes) |
| `NEWS.gz` | Generated at build time | `NEWS.gz` | CI (from upstream GitHub release notes) |

## How the changelog works

The `debian/changelog` file is **generated at build time** by
`packaging_files/generate_changelog.sh`. It reads past entries from
`packaging_files/changelog` and prepends a new entry with the correct
version and date.

After a successful build, the `update-repo` job commits the generated
changelog back to `packaging_files/changelog`, so the history accumulates
automatically across builds.

**The static `packaging_files/changelog` is NOT installed directly.**
It is the history source that the script reads from.

### Why this approach

Upstream ollama releases happen automatically via tag pushes — no agent
is involved. `dpkg-buildpackage` reads the version from `debian/changelog`,
so it must be generated with the correct version at build time.

## Agent workflow for changelog

**No manual workflow required.** The CI handles everything:
1. Build generates `debian/changelog` with correct version
2. `update-repo` job commits it back to `packaging_files/changelog`
3. Next build picks up the accumulated history

If you need to manually add a historical entry (e.g., for a version
that was built before this automation existed), add it to the top of
`packaging_files/changelog` following the format below.

## Changelog format

The `packaging_files/changelog` file uses the strict Debian changelog format.
Each entry must follow this structure exactly:

```
package (version) distribution; urgency=level

  * change detail
  * more change detail

 -- maintainer name <email>  RFC-2822-date
```

### Rules

- **Header line**: `ollama (VERSION) DISTRIBUTION; urgency=medium` — no leading whitespace
- **Bullet items**: two spaces + `* ` + change text. Continuation lines indented
  to align with the text start (column 4)
- **Trailer line**: exactly one space before `--`, two spaces between email and date
- **Date format**: RFC 2822, e.g. `Wed, 03 Sep 2025 12:00:00 +0000`
- **Distribution**: `stable` for releases, `unstable` for release candidates
- **Version**: no `v` prefix. Use `~` (not `-`) for pre-release suffixes
  (e.g. `0.22.1~rc0`). Use `+repackN` for rebuilds.
- **Encoding**: UTF-8

### Example entry

```
ollama (0.31.0) stable; urgency=medium

  * Description of packaging change
  * Another change

 -- lingfish <lingfish@users.noreply.github.com>  Mon, 01 Jan 2026 12:00:00 +0000
```

### Getting the date

Use the git tag date for the version being documented:

```bash
git log -1 --format="%ai" "refs/tags/v0.33.3"
```

Then convert to RFC 2822:

```bash
git log -1 --format="%ai" "refs/tags/v0.33.3" | xargs -I{} date -d "{}" -R
```

### Version conversion from git tag

The CI converts git tags to Debian versions:
- `v1.2.3` → `1.2.3`
- `v1.2.3-rc1` → `1.2.3~rc1`
- `v1.2.3+repack2` → `1.2.3+repack2`

## When to update NEWS.Debian

Update `packaging_files/NEWS` **only** for significant user-facing
changes that warrant explicit notification. Examples:
- Package split or merge
- Config file location changes
- Dropped support for architectures or distributions
- Changes to default behavior that could break existing setups

Do **not** update for routine releases, minor fixes, or CI/packaging changes.

The file format is the same as `debian/changelog` but without asterisks.
Use full paragraphs to describe the change.

## When to update README.Debian

Update `packaging_files/README.Debian` when:
- New packages are added to the split
- Installation instructions change
- Configuration options change
- The APT repository setup changes

## How CI uses these files

1. `dh_make` generates a boilerplate `debian/changelog`
2. Packaging files are copied to `debian/`, **excluding** `changelog` and
   `generate_changelog.sh`
3. `generate_changelog.sh` creates `debian/changelog` with:
   - A new entry for the current version (correct version + today's date)
   - All past entries from `packaging_files/changelog`
4. `dh_installchangelogs --no-trim` installs:
   - `debian/changelog` → `changelog.Debian.gz` (full history, not trimmed)
   - `debian/NEWS` → `NEWS.Debian.gz`
5. Upstream release notes are fetched from GitHub and installed as `NEWS.gz` via `dh_install`
6. `debian/README.Debian` is installed as-is by debhelper
7. After build, `update-repo` commits `packaging_files/changelog` back to repo

## Validation

Validate the changelog format before committing:

```bash
dpkg-parsechangelog --file packaging_files/changelog
dpkg-parsechangelog --file packaging_files/NEWS
```

Both should parse without errors.
