# Moodle Docker Container

## Setup

1. Install Docker on your system.

#### Basic steps for CentOS 7.

```
$ sudo yum install -y yum-utils \
  device-mapper-persistent-data \
  lvm2

$ sudo yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo

$ sudo yum install docker-ce

$ sudo pip install docker-compose
```

2. Create Moodle volumes, then download and extract moodle code

```
$ mkdir -p /opt/moodle/ssl

$ mkdir /opt/moodledata

$ wget https://download.moodle.org/download.php/stable34/moodle-3.4.1.tgz

$ tar -xzvf moodle-3.4.1.tgz -O /opt/moodle/
```

3. Copy dockerfiles from the moodle-docker repository and build the containers

```
$ git clone git@agra.sdelements.com:deployment/moodle-docker.git

$ cd moodle-docker && ./build.sh
```

4. Build postgres container from the Dockerfile

```
$ git clone git@agra.sdelements.com:deployment/docker-postgres.git && cd docker-postgres/9.6/alpine && docker build -t moodle-postgres .
```

5. Configure and start the docker containers with the docker-compose file

```
$ docker-compose up -d
```



