## Summary
This container is used to build DEB packages using the [fpm](https://github.com/jordansissel/fpm) utility. It uses files and directories from this repo as the source artifacts to generate Debian packaging files and the final DEB installer. 

## Build the container

1. Use `docker` to make the container. E.g.:
    ```bash
    docker build -t fpm:deb ./deb-builder/
    ```


## Create DEB file

1. Make a `docker-compose` file with your attributes. Use `dc.deb.yml` as an example.

2. Finally, use `docker-compose` to create the DEB file
    ```bash
    docker-compose -f dc.deb.yml up
    ```
    
## Sample output

```bash
Creating moodle-docker_deb-build_1 ... done
Attaching to moodle-docker_deb-build_1
deb-build_1  | {:timestamp=>"2018-08-15T18:48:38.706487+0000", :message=>"Setting workdir", :workdir=>"/tmp", :level=>:info}
deb-build_1  | {:timestamp=>"2018-08-15T18:48:38.713277+0000", :message=>"Setting from flags: category=web", :level=>:info}
deb-build_1  | {:timestamp=>"2018-08-15T18:48:38.713372+0000", :message=>"Setting from flags: description=Docker based Moodle Deployment\nThis project deploys the Moodle (Modular Object-Oriented Dynamic Learning\nEnvironment) course management system using one Docker container that runs\nboth Nginx and PHP/PHP-FPM services", :level=>:info}
deb-build_1  | {:timestamp=>"2018-08-15T18:48:38.713495+0000", :message=>"Setting from flags: epoch=", :level=>:info}
deb-build_1  | {:timestamp=>"2018-08-15T18:48:38.713564+0000", :message=>"Setting from flags: iteration=", :level=>:info}
deb-build_1  | {:timestamp=>"2018-08-15T18:48:38.713608+0000", :message=>"Setting from flags: license=MIT", :level=>:info}
deb-build_1  | {:timestamp=>"2018-08-15T18:48:38.713657+0000", :message=>"Setting from flags: maintainer=Security Compass <devops@securitycompass.com>", :level=>:info}
deb-build_1  | {:timestamp=>"2018-08-15T18:48:38.713707+0000", :message=>"Setting from flags: name=moodle-docker", :level=>:info}
deb-build_1  | {:timestamp=>"2018-08-15T18:48:38.713746+0000", :message=>"Setting from flags: url=https://www.securitycompass.com/", :level=>:info}
deb-build_1  | {:timestamp=>"2018-08-15T18:48:38.713828+0000", :message=>"Setting from flags: vendor=Security Compass <devops@securitycompass.com>", :level=>:info}
deb-build_1  | {:timestamp=>"2018-08-15T18:48:38.713988+0000", :message=>"Setting from flags: version=7.2-3.5", :level=>:info}
deb-build_1  | {:timestamp=>"2018-08-15T18:48:38.714082+0000", :message=>"Converting dir to deb", :level=>:info}
deb-build_1  | {:timestamp=>"2018-08-15T18:48:38.718823+0000", :message=>"Writing user-specified changelog", :source=>"/package/CHANGELOG.md", :level=>:info}
deb-build_1  | {:timestamp=>"2018-08-15T18:48:38.719095+0000", :message=>"No deb_installed_size set, calculating now.", :level=>:info}
deb-build_1  | {:timestamp=>"2018-08-15T18:48:38.720160+0000", :message=>"Reading template", :path=>"/var/lib/gems/2.3.0/gems/fpm-1.10.2/templates/deb.erb", :level=>:info}
deb-build_1  | {:timestamp=>"2018-08-15T18:48:38.721747+0000", :message=>"Debian packaging tools generally labels all files in /etc as config files, as mandated by policy, so fpm defaults to this behavior for deb packages. You can disable this default behavior with --deb-no-default-config-files flag", :level=>:warn}
deb-build_1  | {:timestamp=>"2018-08-15T18:48:38.724788+0000", :message=>"Creating", :path=>"/tmp/package-deb-build-e3bdb4778f4f633e6b7ed6e5d07979467808a99b5c867152fa9afd86d0ee/control.tar.gz", :from=>"/tmp/package-deb-build-e3bdb4778f4f633e6b7ed6e5d07979467808a99b5c867152fa9afd86d0ee/control", :level=>:info}
deb-build_1  | {:timestamp=>"2018-08-15T18:48:38.751797+0000", :message=>"Created package", :path=>"/package/moodle-docker-7.2-3.5.deb"}
moodle-docker_deb-build_1 exited with code 0
```

## DEB Package Artifacts

### Application and Debian packaging files

```bash
# dpkg -x moodle-docker-7.2-3.5.deb /tmp/moodle
# tree /tmp/moodle
/tmp/moodle
├── conffiles
├── control
├── etc
│   └── moodle-docker
│       ├── conf
│       │   └── etc
│       │       ├── nginx
│       │       │   ├── conf.d
│       │       │   │   └── moodle.template
│       │       │   ├── nginx.conf
│       │       │   └── ssl
│       │       │       ├── moodle.crt
│       │       │       └── moodle.key
│       │       └── php
│       │           └── 7.2
│       │               ├── fpm
│       │               │   ├── php-fpm.conf
│       │               │   ├── php.ini
│       │               │   └── pool.d
│       │               │       └── www.conf
│       │               └── mods-available
│       │                   └── opcache.ini
│       ├── dc.prod-dbonly.yml
│       ├── dc.prod.yml
│       └── docker-compose.yml
├── md5sums
└── usr
    └── share
        └── doc
            └── moodle-docker
                └── changelog.gz

16 directories, 16 files
```
