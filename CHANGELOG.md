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

### Changed
- Update README to mention arm64 packaging

## [0.18.1] - 2026-03-17
### Changed
- Initial packaging release (no packaging-specific changes)

## [0.17.5] - 2026-03-02
### Changed
- Add Buy Me a Coffee funding option
- Add donation link and usage instructions to README
