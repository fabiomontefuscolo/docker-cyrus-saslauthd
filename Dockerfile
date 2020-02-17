FROM centos:8
LABEL author "Fabio Montefuscolo <fabio.montefuscolo@gmail.com>"

RUN yum install -y                                                                       \
        cyrus-sasl                                                                       \
        cyrus-sasl-gs2                                                                   \
        cyrus-sasl-sql                                                                   \
        cyrus-sasl-ldap                                                                  \
        cyrus-sasl-scram                                                                 \
        cyrus-sasl-ntlm                                                                  \
        cyrus-sasl-gssapi                                                                \
        cyrus-sasl-plain                                                                 \
        cyrus-sasl-devel                                                                 \
        cyrus-sasl-lib                                                                   \
        cyrus-sasl-md5                                                                   \
        glibc-langpack-en                                                                \
    && yum --enablerepo='*' clean all

ENV SYSLOG_SOCK=/run/rsyslog/dev/log

RUN mkdir -p /etc/saslauthd.conf.d
VOLUME /run /etc/saslauthd.conf.d

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

CMD ["/usr/sbin/saslauthd", "-V", "-d", "-m", "/run/saslauthd", "-a", "ldap"]