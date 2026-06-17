# Changelog

All notable changes to this project will be documented in this file.

## [v0.30.8+repack1]

### Added
- Split shared libraries into new `libollama-common` package containing CPU dispatch libraries and Vulkan backend
- Add `Replaces`/`Breaks` to `libollama-common` for clean upgrades from older package layouts
- Register `/usr/lib/ollama/` on the standard library search path
- Add postinst script to join the `ollama` user to `render` and `video` groups
- Add `+repackN` suffix for rebuilds of the same upstream version
- Add issue templates for bug reports and feature requests

### Changed
- Migrate from `dh-sysuser` to `dh_installsysusers` for user creation

### Fixed
- Remove `Multi-Arch: same` from `libollama-common` — pydeb-s3 drops `Multi-Arch` from Packages metadata, causing APT to see repo and installed versions as different packages and trigger a same-version reinstall on every `apt dist-upgrade`
- Fix `+repackN` suffix: now only applied to Debian package version metadata, not to build directory names or archive paths
- Add versioned dependency `libollama-common (= ${binary:Version})` to `ollama`, `libollama-nvidia`, and `libollama-amd` so APT upgrades `libollama-common` when upgrading the parent package

## [v0.22.1 – v0.23.0]

### Changed
- Replace pydeb-s3 installation with `pipx run` instead of a shell wrapper
- Add clean phase to CI workflow using pydeb-s3

## [v0.22.0 – v0.22.1-rc0]

### Added
- Migrate to pydeb-s3 for repository management
- Support multiple codenames in APT repository

## [v0.21.2 – v0.21.3-rc0]

### Added
- Add `rc` suite and switch to `non-free` component
- Enable release workflow; remove reprepro `Limit` directive
- Use `rclone sync` instead of `r2-upload-action` for release uploads
- Use xz level 2 for faster compression

## [v0.21.1]

### Changed
- Disable compression for all packages to speed up build

## [v0.21.0 – v0.21.1-rc1]

### Added
- Split large deb packages to work around GitHub 2 GB release limit (reverted shortly after)

### Changed
- Migrate back to S3 buckets for artifact storage

## [v0.20.2 – v0.20.3]

### Added
- Add arm64 architecture support to APT distributions
- Fix reprepro command to not ignore exit codes

## [v0.20.4-rc2]

### Changed
- Update documentation to dynamically configure correct architecture in APT sources

## [v0.18.2 – v0.18.3-rc1]

### Added
- Add sysvinit init script for non-systemd distributions (Devuan, Alpine)
- Add debhelper systemd/sysvinit dual support
- Add `skip_release` workflow input for testing builds
- Start tracking packaging changes in CHANGELOG.md

### Fixed
- Remove `--with systemd` flag from debhelper (incompatible with compat level 11+)

## [v0.18.1 – v0.18.2-rc0]

### Added
- Add arm64 architecture support

## [v0.14.2 – v0.14.3-rc0]

### Fixed
- Fix build for new zst archive format

## [v0.12.5 – v0.12.8]

### Added
- Add disk space cleanup step to CI workflow

## [v0.11.0 – v0.11.2]

### Added
- Add APT repository support with reprepro
- Add git-lfs for repository data

## [v0.9.0 – v0.9.1]

### Added
- Split NVIDIA and AMD shared libraries into separate `libollama-nvidia` and `libollama-amd` packages
- Include ollama upstream release notes in GitHub release body

## [v0.5.8 – v0.5.8-rc11]

### Added
- Generate deb file listing and upload to releases
- Improve CONTENTS.md generation

## [v0.5.4 – v0.5.5]

### Changed
- Simplify `debian/install` file; use `dh_install` recursion

## [v0.4.0 – v0.4.5]

### Changed
- Update packaging rules for ollama's bundled libraries

## [v0.3.10 – v0.3.13]

### Added
- Initial packaging via GitHub Actions workflow
