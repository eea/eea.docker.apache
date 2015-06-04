FROM centos:7
MAINTAINER "Vitalie Maldur" <vitalie.maldur@eaudeweb.ro>
MAINTAINER "Alin Voinea" <alin.voinea@eaudeweb.ro>

ENV UID 1000
ENV USER apache

RUN useradd -u $UID -m -s /bin/bash $USER
RUN yum -y updateinfo
RUN yum -y install httpd

# Cleanup cache
RUN yum clean all

RUN chown -R $UID:$UID /var/www

EXPOSE 80

ADD run-httpd.sh /run-httpd.sh
RUN chmod -v +x /run-httpd.sh

CMD ["/run-httpd.sh"]
