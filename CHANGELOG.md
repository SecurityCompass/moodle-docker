# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## [0.1.0] - 2017-08-13
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
