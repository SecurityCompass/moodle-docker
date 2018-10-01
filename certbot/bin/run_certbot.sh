#!/bin/sh
# shellcheck disable=SC2039,SC2113

set -e

print_usage() {
cat << EOF
usage: ${0} options

This script helps to update content views in Foreman.

OPTIONS:
    Parameters:
    -d Domain for certificate.
    -e Administrator email used when obtaining certificates.
    -r Webroot location to place challenge auth files.
    -A Additional arguments to pass to certbot command.
    -D Enable debug mode for additional output.
    -S Enable staging mode for test certificates.

Version: ${VERSION}
EOF
}

function is_domain {
    # Ensure cert_domain value is a hostname and not IP address.
    if [ -z "${1}" ] ; then
        echo "Missing parameter 1: Domain name"
        return 1
    fi

    local cert_domain="${1}"

    if [[ "${cert_domain}" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
        return 1
    else
        return 0
    fi
}

function check_for_cert {
    # Check if certificate directory exists
    if [ -z "${1}" ] ; then
        echo "Missing parameter 1: Domain name"
        return 1
    fi

    local cert_domain="${1}"
    local cert_dir="/etc/letsencrypt/live/${cert_domain}"

    if [ -d "${cert_dir}" ] ; then
        echo "Found ${cert_dir}."
        return 0
    else
        echo "${cert_dir} not found."
        return 1
    fi
}

function copy_certificates {
    # Copy certificate files to /certs/ docker volume
    # Check if certificate directory exists
    if [ -z "${1}" ] ; then
        echo "Missing parameter 1: Domain name"
        return 1
    fi

    local cert_domain="${1}"

    cp -v /etc/letsencrypt/live/"${cert_domain}"/cert.pem /certs/"${cert_domain}".pem
    cp -v /etc/letsencrypt/live/"${cert_domain}"/privkey.pem /certs/"${cert_domain}".key.pem
    cp -v /etc/letsencrypt/live/"${cert_domain}"/chain.pem /certs/"${cert_domain}".chain.pem
    cp -v /etc/letsencrypt/live/"${cert_domain}"/fullchain.pem /certs/"${cert_domain}".fullchain.pem
}

function obtain_certificate {
    # Obtain certificate for provided domain
    if [ -z "${1}" ] ; then
        echo "Missing parameter 1: Admin email"
        return 1
    fi
    if [ -z "${2}" ] ; then
        echo "Missing parameter 2: Certificate domain name"
        return 1
    fi
    if [ -z "${3}" ] ; then
        echo "Missing parameter 3: Webroot location"
        return 1
    fi

    local admin_email="${1}"
    local certificate_domain="${2}"
    local certificate_webroot="${3}"

    echo "Obtaining certificate for ${certificate_domain}"

    certbot certonly \
        --webroot -w "${certificate_webroot}" \
        --keep-until-expiring \
        --agree-tos \
        --renew-by-default \
        --non-interactive \
        --max-log-backups 100 \
        --email "${admin_email}" \
        --domain "${certificate_domain}"
}

function renew_certificate {
    # Renew certificate for provided domain
    local certbot_args="${4:-}"

    if [ "$STAGING" = true ]; then
        certbot_args=$certbot_args" --staging"
    fi
    if [ "$DEBUG" = true ]; then
        certbot_args=$certbot_args" --debug"
    fi

    echo "Renewing certificates registered on system."
    certbot renew \
        --webroot -w "${cert_webroot}" \
        --non-interactive \
        --deploy-hook copy_certificates.sh
}

function process_certificates {
    # Check certificate for expiry, renew if required and move to correct location.
    if [ -z "${1}" ] ; then
        echo "Missing parameter 1: Admin email"
        return 1
    fi

    if [ -z "${2}" ] ; then
        echo "Missing parameter 2: Certificate domain name"
        return 1
    fi
    if [ -z "${3}" ] ; then
        echo "Missing parameter 3: Webroot location"
        return 1
    fi

    local admin_email="${1}"
    local cert_domain="${2}"
    local cert_webroot="${3}"
    local certbot_args="${4:-}"

    if is_domain "${cert_domain}" ; then
        if check_for_cert "${cert_domain}" ; then
            renew_certificate "${admin_email}" "${cert_domain}" "${cert_webroot}" "${certbot_args}"
        else
            obtain_certificate "${admin_email}" "${cert_domain}" "${cert_webroot}" "${certbot_args}"
        fi

        copy_certificates "${cert_domain}"
    else
        echo "Hostname appears to be IP address, not obtaining certificates."
        exit 1
    fi
}

admin_email="${admin_email:-}"
certificate_domain="${certificate_domain:-}"
certificate_webroot="${certificate_webroot:-}"
staging="${staging:-}"
certbot_args="${certbot_args:-}"
while getopts ":d:e:r:A:SD" opt; do
    case ${opt} in
        'd') certificate_domain="${OPTARG}" ;;
        'r') certificate_webroot="${OPTARG}" ;;
        'e') admin_email="${OPTARG}" ;;
        'A') certbot_args="${OPTARG}" ;;
        'S') STAGING=true ;;
        'D') DEBUG=true ;;
        '?')
            echo "Invalid option: -${OPTARG}"
            print_usage
            exit 0
        ;;
        ':')
            echo "Missing option argument for -${OPTARG}"
            print_usage
            exit 0
        ;;
        '*')    # Anything else
            echo "Unknown error while processing options"
            print_usage
            exit 1
        ;;
    esac
done

process_certificates "${admin_email}" "${certificate_domain}" "${certificate_webroot}" "${certbot_args}"
