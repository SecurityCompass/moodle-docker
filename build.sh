#!/bin/bash

cd nginx && docker build -t moodle-nginx . && cd ..

cd php-fpm && docker build -t moodle-fpm . && cd ..
