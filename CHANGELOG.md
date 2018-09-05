# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## [0.1.2] - 2018-09-04
### Added
- DEB Package
  - Added `iteration` to DEB name
  - `.env.example` so we have a sample
  - `.env` file creation from `.env.example` and customization
  - Random password generator

### Changed
- Bumped Moodle version to 3.5.1

### Removed
- Explicit Deb filename, `fpm` will create it using `version` and `iteration`

## [0.1.1] - 2018-08-23
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

## [0.1.0] - 2018-08-13
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
