FROM httpd:2.4

MAINTAINER "Alin Voinea" <alin.voinea@eaudeweb.ro>
MAINTAINER "Daniel Marinovici" <daniel.marinovici@eaudeweb.ro>

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      libaprutil1-ldap \
      openssl \
      python3-pip && \
    rm -r /var/lib/apt/lists/*

RUN pip3 install chaperone

RUN sed -i 's|#LoadModule rewrite_module|LoadModule rewrite_module|' /usr/local/apache2/conf/httpd.conf && \
    sed -i 's|#LoadModule proxy_module|LoadModule proxy_module|' /usr/local/apache2/conf/httpd.conf && \
    sed -i 's|#LoadModule proxy_http_module|LoadModule proxy_http_module|' /usr/local/apache2/conf/httpd.conf && \
    sed -i 's|#LoadModule deflate_module modules/mod_deflate.so|LoadModule deflate_module modules/mod_deflate.so|' /usr/local/apache2/conf/httpd.conf && \
    sed -i 's|#Include conf/extra/httpd-autoindex.conf|Include conf/extra/httpd-autoindex.conf|' /usr/local/apache2/conf/httpd.conf && \
    echo 'IncludeOptional conf/extra/vh-*.conf' >> /usr/local/apache2/conf/httpd.conf && \
    # ldap:
    sed -i 's|#LoadModule ldap_module|LoadModule ldap_module|' /usr/local/apache2/conf/httpd.conf && \
    sed -i 's|#LoadModule authnz_ldap_module|LoadModule authnz_ldap_module|' /usr/local/apache2/conf/httpd.conf && \
    # session:
    sed -i 's|#LoadModule session_module|LoadModule session_module|' /usr/local/apache2/conf/httpd.conf && \
    sed -i 's|#LoadModule session_cookie_module|LoadModule session_cookie_module|' /usr/local/apache2/conf/httpd.conf && \
    sed -i 's|#LoadModule session_dbd_module|LoadModule session_dbd_module|' /usr/local/apache2/conf/httpd.conf && \
    sed -i 's|#LoadModule auth_form_module|LoadModule auth_form_module|' /usr/local/apache2/conf/httpd.conf && \
    sed -i 's|#LoadModule request_module|LoadModule request_module|' /usr/local/apache2/conf/httpd.conf && \
    # ssl:
    sed -i 's|#LoadModule ssl_module|LoadModule ssl_module|' /usr/local/apache2/conf/httpd.conf && \
    sed -i 's|#LoadModule socache_shmcb_module|LoadModule socache_shmcb_module|' /usr/local/apache2/conf/httpd.conf && \
    sed -i 's|#Include conf/extra/httpd-ssl.conf|Include conf/extra/httpd-ssl.conf|' /usr/local/apache2/conf/httpd.conf && \
    sed -i 's|#ServerName www.example.com:80|ServerName eeacms-apache.docker.com|' /usr/local/apache2/conf/httpd.conf

RUN groupadd -g 400 apache && useradd -u 400 -g apache apache && \
    chown -R apache:apache /usr/local/apache2

RUN sed -i 's|User daemon|User apache|' /usr/local/apache2/conf/httpd.conf && \
    sed -i 's|Group daemon|Group apache|' /usr/local/apache2/conf/httpd.conf

ADD src/docker-setup.sh  /docker-setup.sh
ADD src/reload.sh        /bin/reload
ADD src/chaperone.conf   /etc/chaperone.d/chaperone.conf

ENTRYPOINT ["/usr/local/bin/chaperone"]
