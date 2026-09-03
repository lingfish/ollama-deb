# Agent Maintenance Guide

This file documents what agents need to know to maintain the Debian packaging
changelog, NEWS, and README files.

## Files overview

| File | Location | Installed as | Maintained by |
|------|----------|-------------|---------------|
| `changelog` | `packaging_files/changelog` | `changelog.Debian.gz` | Agent (before each release) |
| `NEWS.Debian` | `packaging_files/NEWS.Debian` | `NEWS.Debian.gz` | Agent (significant changes only) |
| `README.Debian` | `packaging_files/README.Debian` | `README.Debian` | Agent (when structure changes) |
| `NEWS.gz` | Generated at build time | `NEWS.gz` | CI (from upstream GitHub release notes) |

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

## When to update the changelog

Update `packaging_files/changelog` **before** each release. Add a new entry
at the top of the file with:

1. The correct version (matching `VERSION_NO_V_DEB` from the CI workflow)
2. The appropriate distribution (`stable` or `unstable`)
3. Bullet points describing the packaging changes in this version
4. Current date in RFC 2822 format

The CI workflow overwrites `debian/changelog` via `cp -v ../packaging_files/* debian/`,
so no CI changes are needed.

### Version conversion from git tag

The CI converts git tags to Debian versions:
- `v1.2.3` → `1.2.3`
- `v1.2.3-rc1` → `1.2.3~rc1`
- `v1.2.3+repack2` → `1.2.3+repack2`

## When to update NEWS.Debian

Update `packaging_files/NEWS.Debian` **only** for significant user-facing
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
2. `cp -v ../packaging_files/* debian/` overwrites it with the committed version
3. `dh_installchangelogs --no-trim` installs:
   - `debian/changelog` → `changelog.Debian.gz` (full history, not trimmed)
   - `debian/NEWS` → `NEWS.Debian.gz`
4. Upstream release notes are fetched from GitHub and installed as `NEWS.gz`
5. `debian/README.Debian` is installed as-is by debhelper

## Validation

Validate the changelog format before committing:

```bash
dpkg-parsechangelog --file packaging_files/changelog
dpkg-parsechangelog --file packaging_files/NEWS.Debian
```

Both should parse without errors.
