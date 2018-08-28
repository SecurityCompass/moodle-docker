#!/bin/sh
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
#!/usr/bin/env bash

systemctl --system daemon-reload >/dev/null || true
systemctl enable moodle-docker >/dev/null || true
# Skip starting since we need to configure `.env`
#systemctl start moodle-docker >/dev/null || true
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
