# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## [v0.1.5] - 2018-09-17
### Added
- Certbot container for obtaining Lets Encrypt certificates

## [v0.1.4] - 2018-09-14
### Added
- New ENV variables to configure HTTP and HTTPS ports for Nginx

### Changed
- Update README

### Removed
- Remove deprecated docker-compose configuration files

## [v0.1.3] - 2018-09-07
### Added
- Travis CI jobs
  - Dockerfile linter
  - Docker image build and publish to Cargo
  - DEB package build
  - SDLC script to ensure version bumps

### Changed
- Minor bug fixes for `dc.deb.yml`
- Minor updates to the Moodle and DEB `Dockerfile`
- Strict mode and copyright notice in bash scripts

## [v0.1.2] - 2018-09-04
### Added
- DEB Package
  - Added `iteration` to DEB name
  - `.env.example` so we have a sample
  - `.env` file creation from `.env.example` and customization
  - Random password generator

### Changed
- Bumped Moodle version to 3.5.1

### Removed
- Explicit DEB filename, `fpm` will create it using `version` and `iteration`

## [v0.1.1] - 2018-08-23
### Added
- `systemd` files to DEB package
  - `docker-moodle` unit file
  - `preinst` and `prerm` scripts
- Add configurable Docker registry URL

### Changed
- Build from the latest stable Moodle build
- Update DEB builder `README.md`
- Fetch images from Docker registry URL by default
- Update `README.md` with latest changes

## [v0.1.0] - 2018-08-13
### Added
- Project `CHANGELOG.md`
- Container for building DEB packages
  - `Dockerfile` for container
  - `dc.deb.yml` `docker-compose` configuration
  - `README.md` with instructions and samples
- Travis CI configuration to check shell scripts
- `README.md` summary

### Changed
- Update/re-add `docker-compose` version
- Fix DB volume type in main `docker-compose` configuration
- Fix shellcheck errors in `*.sh` scripts

### Removed
- Unused/empty `config.php` from `conf`
- Remove `docker-postgres` Git submodule
