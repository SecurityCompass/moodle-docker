#!/bin/sh

# Create string of random characters
#  - First param is length, default: 20
#  - Second param is characters, default: A-Za-z0-9_
gen_rand_chars() {
    LC_CTYPE=C tr -dc "${2:-A-Za-z0-9_}" < /dev/urandom | head -c "${1:-20}"
}

after_upgrade() {
    :

systemctl --system daemon-reload >/dev/null || true
if ! systemctl is-enabled moodle-docker >/dev/null
then
    systemctl enable moodle-docker >/dev/null || true
    systemctl start moodle-docker >/dev/null || true
else
    systemctl restart moodle-docker >/dev/null || true
fi
}

after_install() {
    :

echo "Checking Moodle data directory"
if [ ! -d /opt/moodle/moodledata ]; then
    echo "Creating Moodle data directory"
    mkdir -p /opt/moodle/moodledata
    chmod 770 /opt/moodle/moodledata
else
    echo "Moodle data directory already exists"
fi

echo "Setting up .env file"
if [ ! -f /etc/moodle-docker/.env ]; then
    echo "Creating .env from example file"
    cp /etc/moodle-docker/.env.example /etc/moodle-docker/.env

    echo "Configuring .env..."
    moodle_admin_pass="$(gen_rand_chars 32)"
    moodle_upgrade_key="$(gen_rand_chars 32)"
    pgsql_password="$(gen_rand_chars 32)"
    sed -i "s/MOODLE_ADMIN_PASS=.*/MOODLE_ADMIN_PASS=${moodle_admin_pass}/g" /etc/moodle-docker/.env
    sed -i "s/MOODLE_UPGRADE_KEY=.*/MOODLE_UPGRADE_KEY=${moodle_upgrade_key}/g" /etc/moodle-docker/.env
    sed -i "s/PGSQL_PASSWORD=.*/PGSQL_PASSWORD=${pgsql_password}/g" /etc/moodle-docker/.env
    sed -i "s#MOODLE_BACKUP_ROOT=.*#MOODLE_BACKUP_ROOT=/backups#g" /etc/moodle-docker/.env
else
    echo "Nothing to do, .env already exists"
fi

echo "Configuring and enabling systemd units"
systemctl --system daemon-reload >/dev/null || true
systemctl enable moodle-docker >/dev/null || true

echo "Configuration complete, configure/populate '/etc/moodle-docker/.env' before starting Moodle."
}

if [ "${1}" = "configure" ] && [ -z "${2}" ] || \
   [ "${1}" = "abort-remove" ]
then
    # "after install" here
    # "abort-remove" happens when the pre-removal script failed.
    #   In that case, this script, which should be idemptoent, is run
    #   to ensure a clean roll-back of the removal.
    after_install
elif [ "${1}" = "configure" ] && [ -n "${2}" ]
then
    upgradeFromVersion="${2}"
    # "after upgrade" here
    # NOTE: This slot is also used when deb packages are removed,
    # but their config files aren't, but a newer version of the
    # package is installed later, called "Config-Files" state.
    # basically, that still looks a _lot_ like an upgrade to me.
    after_upgrade "${upgradeFromVersion}"
elif echo "${1}" | grep -E -q "(abort|fail)"
then
    echo "Failed to install before the post-installation script was run." >&2
    exit 1
fi
