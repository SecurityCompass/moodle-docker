#!/bin/bash

cd moodle-app && docker build -t moodle-app-3.4.2 . && cd ..

cd nginx && docker build -t moodle-nginx . && cd ..

cd php-fpm && docker build -t moodle-php-fpm . && cd ..
