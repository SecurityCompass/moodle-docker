#!/bin/bash

set -e

VERSION='0.1'

DOCKER_COMPOSE=$(which docker-compose)
BASE_COMPOSE='/etc/moodle-docker/docker-compose.yml'
THEME_COMPOSE='/etc/moodle-docker/dc.theme-dev.yml'
BASE_COMMAND="${DOCKER_COMPOSE} --file ${BASE_COMPOSE}"

THEME_DIR='/opt/moodle/theme'

# Print usage and argument list
function print_usage {
cat << EOF
usage: ${0} options

This script will create an organization and update the associated DNS record.

OPTIONS:
Actions:
    clean
    down
    stop
    restart
    up
    version, -v, --version  Print ${0} version and exit

Parameters:
    -d      Detach from running docker-compose containers
    -t      Mount theme directory to host for theme development

Examples:
"${0} start -d -t" Start Moodle in detached mode with theme directory mounted to host.

Version: ${VERSION}
EOF
}

function ensure_theme_dir {
    if [ ! -d "${THEME_DIR}" ] ; then
        echo "Theme directory not found, creating ${THEME_DIR}"
        mkdir -p "${THEME_DIR}"
    fi
}

function clean_moodle {
    local compose_command="${BASE_COMMAND}"

    if [ "${THEME_DEV}" == 'True' ] ; then
        compose_command="${compose_command} --file ${THEME_COMPOSE}"
    fi
    compose_command="${compose_command} rm"

    eval "${compose_command}"
}

function down_moodle {
    local compose_command="${BASE_COMMAND}"

    if [ "${THEME_DEV}" == 'True' ] ; then
        compose_command="${compose_command} --file ${THEME_COMPOSE}"
    fi
    compose_command="${compose_command} down"

    eval "${compose_command}"
}

function stop_moodle {
    local compose_command="${BASE_COMMAND}"

    if [ "${THEME_DEV}" == 'True' ] ; then
        compose_command="${compose_command} --file ${THEME_COMPOSE}"
    fi
    compose_command="${compose_command} stop"

    eval "${compose_command}"
}

function restart_moodle {
    local compose_command="${BASE_COMMAND}"

    if [ "${THEME_DEV}" == 'True' ] ; then
        ensure_theme_dir
        compose_command="${compose_command} --file ${THEME_COMPOSE}"
    fi
    compose_command="${compose_command} restart"

    eval "${compose_command}"
}

function up_moodle {
    local compose_command="${BASE_COMMAND}"

    if [ "${THEME_DEV}" == 'True' ] ; then
        ensure_theme_dir
        compose_command="${compose_command} --file ${THEME_COMPOSE}"
    fi
    compose_command="${compose_command} up"

    if [ "${DETACH}" == 'True' ] ; then
        compose_command="${compose_command} --detach"
    fi

    eval "${compose_command}"
}

subcommand="${1:-}"
shift

while getopts ":dt" opt; do
    case ${opt} in
        'd') DETACH='True' ;;
        't') THEME_DEV='True' ;;
        '?')
            color_echo red "Invalid option: -${OPTARG}"
            print_usage
            exit 0
        ;;
        ':')
            color_echo red "Missing option argument for -${OPTARG}"
            print_usage
            exit 0
        ;;
        '*')    # Anything else
            color_echo red "Unknown error while processing options"
            print_usage
            exit 1
        ;;
    esac
done

# Run the right subcommand
case "${subcommand}" in
    'start'|'up')
        up_moodle

        exit 0
    ;;
    'stop')
        stop_moodle

        exit 0
    ;;
    'restart')
        restart_moodle

        exit 0
    ;;
    'down')
        down_moodle

        exit 0
    ;;
    'clean')
        clean_moodle

        exit 0
    ;;
    'help'|'--help'|'-h')     # Help
        print_usage
        exit 0
    ;;
    'version'|'--version'|'-v')  # Version
        color_echo green "Version: ${VERSION}"
        exit 0
    ;;
    *)          # Invalid subcommand
        color_echo red "Invalid subcommand \"${subcommand}\""
        print_usage
        exit 64
    ;;
esac


