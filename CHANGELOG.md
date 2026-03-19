# Changelog

All notable changes to this project will be documented in this file.

## [Unreleased]

## [0.18.1] - 2026-03-19
### Added
- Add sysvinit init script for non-systemd distributions (Devuan, Alpine)
- Add debhelper systemd/sysvinit dual support
- Add `skip_release` workflow input to mainv3.yml for testing builds

### Fixed
- Remove `--with systemd` flag from debhelper (incompatible with compat level 11+)
