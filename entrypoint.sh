#!/bin/bash
set -x

if [ -n "$(find /etc/saslauthd.conf.d -type f -name '*.conf')" ];
then
    find /etc/saslauthd.conf.d -type f -name '*.conf' -exec cat {} \; > /etc/saslauthd.conf
fi

[ -n "${SYSLOG_SOCK}" ] && ln -sf "${SYSLOG_SOCK}" /dev/log

if [ -d "/entrypoint.d" ];
then
    for extra in /entrypoint.d/*; do
        case "$extra" in
            *.sh)     . "$extra" ;;
        esac
        echo
    done
    unset extra
fi

exec "$@"
