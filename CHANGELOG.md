# Changelog

All notable changes to this project will be documented in this file.

## [Unreleased]

### Added
- Create `libollama-common` package containing CPU dispatch libraries and Vulkan backend
- `ollama` now Depends on `libollama-common` — CPU inference works out of the box
- GPU packages depend on `libollama-common` and provide `ollama-gpu-backend`
- No conflicts between GPU backends; users can install both NVIDIA and AMD simultaneously

### Fixed
- Fix CPU inference bug for AMD GPU users (CPU dispatch libs now in `libollama-common` instead of `libollama-nvidia`)
- Remove `Multi-Arch: same` from `libollama-common` — pydeb-s3 drops Multi-Arch from Packages metadata, causing APT to see repo and installed versions as different packages and trigger a same-version reinstall on every `apt dist-upgrade`
- Add `repack` workflow input and `+repackN` suffix for rebuilds of the same upstream version
- Fix `+repackN` suffix: only apply to Debian package version metadata, not to build directory names or archive paths (was causing tar to look for wrong filename)

## [0.18.2] - YYYY-MM-DD
### Added
- Add sysvinit init script for non-systemd distributions (Devuan, Alpine)
- Add arm64 architecture support
- Add debhelper systemd/sysvinit dual support
- Add `skip_release` workflow input to mainv3.yml for testing builds

### Fixed
- Remove `--with systemd` flag from debhelper (incompatible with compat level 11+)

## [0.18.0] - 2026-03-14
### Added
- Add arm64 architecture support

## [0.10.1] - 2025-08-01
### Added
- Add APT repository support

## [0.7.1] - 2025-05-25
### Added
- Split shared libs into libollama-nvidia and libollama-amd packages

## [0.4.6] - 2024-12-09
### Added
- Initial release
