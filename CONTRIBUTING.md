# Contributing to `moodle-docker`

## Tags
### Summary
* Tag `develop` after merging feature branches
* Tag `master` after merging `develop`
* Tag creation generate DEB package and pushes container to registry
  * See `.travis.yml` and `bin/travis-ci/*.sh` for details

### Procedure
1. Push changes to appropriate branch (See [Pull Requests](#pull-requests)) 
    * In addition to any code changes, add a new entry in `CHANGELOG.md` with version bump and update `BUILD_VERSION` in `.env` to match
2. Create PR
3. Verify that all status checks pass
4. Merge PR once approved
5. Create a tag on the appropriate branch

## Pull Requests

### Feature Pull Requests
* Base: `develop`
* Increment PATCH version (e.g. `v0.1.12` -> `v0.1.13`)
* Tag `master` after merging PR

### `master` Pull Requests
* Base: `master`
* Increment MINOR version  (e.g. `v0.1.12` -> `v0.2.0`)
* Tag `master` after merging PR
