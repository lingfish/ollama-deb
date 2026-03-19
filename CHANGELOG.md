# Changelog

All notable changes to this project will be documented in this file.

## [Unreleased]

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
