FROM centos:8
LABEL author "Fabio Montefuscolo <fabio.montefuscolo@gmail.com>"

RUN yum install -y epel-release                                                           \
    && yum install -y                                                                     \
         autoconf                                                                         \
         libtool                                                                          \
         make                                                                             \
         gcc                                                                              \
         mariadb-devel                                                                    \
         pam-devel                                                                        \
         rpm-build                                                                        \
         pam_url                                                                          \
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
     && curl -o /tmp/pam-mysql.tar.gz                                                     \
        -L https://github.com/NigelCunningham/pam-MySQL/archive/master.tar.gz             \
     && mkdir /build                                                                      \
     && cd /build                                                                         \
     && tar -C /build --strip-components=1 -zxvf /tmp/pam-mysql.tar.gz                    \
     && autoreconf -f -i                                                                  \
     && ./configure                                                                       \
     && make                                                                              \
     && make install                                                                      \
     && cd /                                                                              \
     && yum remove -y                                                                     \
         autoconf                                                                         \
         libtool                                                                          \
         make                                                                             \
         gcc                                                                              \
         mariadb-devel                                                                    \
         pam-devel                                                                        \
         rpm-build                                                                        \
     && rm -Rf /build                                                                     \
     && rm /tmp/pam-mysql.tar.gz                                                          \
     && yum --enablerepo='*' clean all
 
 ENV SYSLOG_SOCK=/run/rsyslog/dev/log
 
 RUN mkdir -p /etc/saslauthd.conf.d
 VOLUME /run /etc/saslauthd.conf.d
 
 COPY entrypoint.sh /entrypoint.sh
 ENTRYPOINT ["/entrypoint.sh"]
 
 CMD ["/usr/sbin/saslauthd", "-V", "-d", "-m", "/run/saslauthd", "-a", "pam"]
