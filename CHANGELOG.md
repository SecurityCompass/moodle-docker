# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## [v0.1.14] - 2018-11-08
### Added
- Bake in 'postfix' as default smtphost

### Changed
- Clean up Travis CI configuration
- Use new API token in CI
- Simplify container publish script
- Update OneLogin plugin
- Enable logging for PHP

## [v0.1.13] - 2018-10-26
### Added
- Bake in Moodle Custom certificate plugin
- Bake in Moodle Scheduler plugin
- Add `CONTRIBUTION.md`

### Changed
- Clean up Travis CI configuration
- Add deployment support for DEB packages
- Update `check_tag.sh` to handle different scenarios

### Removed
- Unused script, `deb_publish.sh`

## [v0.1.12] - 2018-10-23
### Changed
- Fix `.gitignore` pattern
- Move build variables to Dockerfile
- Bake in files from the `conf` directory (vs. bind mount)
- Rename volume that holds certificates
- Fix ownership and permission for Moodle artifacts
- Remove the use of `MOODLE_VERSION` and `PHP_VERSION` inside the container

### Removed
- Remove `certbot-docker` from this repo
- Clean up unused ENV vars from `docker-compose` configuration files

## [v0.1.11] - 2018-10-17
### Changed
- Update Nginx to 1.14.0-0+xenial2

## [v0.1.10] - 2018-10-17
### Changed
- Update Moove theme to v0.1.1

## [v0.1.9] - 2018-10-11
### Changed
- Fix interpolation bug in `.env`
- Remove `shtdlib` as a Git submodule
- Fix the networks in `docker-compose.yaml`
- Re-add `inotify-tools` in the Moodle `Dockerfile`
- Download `shtdlib` from GH in `setup.sh`

## [v0.1.8] - 2018-10-03
### Added
- A volume to store `config.php` once its created

### Changed
- Refactor `configure-moodle.sh` to support container upgrades

## [v0.1.7] - 2018-10-01
### Added
- Certbot container for obtaining Lets Encrypt certificates

## [v0.1.6] - 2018-09-28
### Added
- Track which version of the Moove theme we install
- Add a build version to container and use it for DEB files

### Changed
- Update tag CI script to use BUILD_VERSION
- Clean up and simplify nginx-php-moodle Dockerfile

## [v0.1.5] - 2018-09-25
### Changed
- Update directory permissions on moodledata directory

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
