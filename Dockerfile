FROM ubuntu:14.04

MAINTAINER digitalutvikling@gmail.com

ENV PATH /usr/bin:/bin:/usr/sbin:/sbin
ENV DEBIAN_FRONTEND noninteractive

ENV REFRESHED_AT 2014-09-23
RUN apt-get -y update && apt-get -y upgrade

# - common

# Missing
# Europe/Oslo:
#  timezone.system:
#    - utc: True

RUN apt-get -y install language-pack-nb openssh-server git 

# - koha.logstash-forwarder
# missing

# - koha
RUN apt-get -y install \ 
	python-software-properties \
	software-properties-common \
	libnet-ssleay-perl   \
	libcrypt-ssleay-perl

# - mysql.server

RUN apt-get install -y mysql-server

# - koha.apache2

RUN apt-get -y install apache2 && \
    a2enmod rewrite && \
    (a2dismod mpm_event || true) && \
    (a2dismod mpm_prefork || true) && \
    a2dissite 000-default && \
    apt-get -y install libapache2-mpm-itk && \
    service apache2 restart && \
    (a2dismod mpm_itk || true) && \
    (a2enmod mpm_itk || true) && \
    a2enmod cgi && \
    service apache2 restart

RUN echo "Listen 8080" >> /etc/apache2/ports.conf && \
    echo "Listen 8081" >> /etc/apache2/ports.conf

# - koha.common

RUN echo "deb http://debian.koha-community.org/koha squeeze main" > /etc/apt/sources.list.d/koha.list && \
    wget -O- http://debian.koha-community.org/koha/gpg.asc | apt-key add - && \
    apt-get -y update && \
    apt-get -y install koha-common=3.16.03 && \
    /etc/init.d/koha-common stop

ENV KOHA_INSTANCE name

ADD files/apache.tmpl /etc/apache2/sites-available/${KOHA_INSTANCE}.conf

RUN sed 's/{{ OpacPort }}/8080/g' -i /etc/apache2/sites-available/${KOHA_INSTANCE}.conf 
RUN sed -e 's/{{ IntraPort }}/8081/g' -i /etc/apache2/sites-available/${KOHA_INSTANCE}.conf  
RUN sed -e "s/{{ ServerName }}/$KOHA_INSTANCE/g" -i /etc/apache2/sites-available/${KOHA_INSTANCE}.conf 

# - koha.restful

RUN apt-get install -y libcgi-application-dispatch-perl && \
    git clone https://github.com/digibib/koha-restful.git /usr/local/src/koha-restful && \
    ln -s /usr/local/src/koha-restful/Koha/REST /usr/share/koha/lib/Koha/REST && \
    ln -s /usr/local/src/koha-restful/opac/rest.pl /usr/share/koha/opac/cgi-bin/opac/rest.pl && \
    mkdir -p /etc/koha/sites/$KOHA_INSTANCE/rest && \
    printf 'authorizedips:\n - "0.0.0.0"\n  - "10.0.2.2"\n  - "192.168.50.11"\ndebug: 1' > \
      /etc/koha/sites/${KOHA_INSTANCE}/rest/config.yaml

# - mysql.client
# omitted

# - koha.sites-config

ADD files/koha-sites.conf /etc/koha/koha-sites.conf

RUN sed -e 's/{{ OpacPort }}/8080/g' -i /etc/koha/koha-sites.conf
RUN sed -e 's/{{ IntraPort }}/8081/g' -i /etc/koha/koha-sites.conf
RUN sed -e "s/{{ ServerName }}/$KOHA_INSTANCE/g" -i /etc/koha/koha-sites.conf

RUN echo "${KOHA_INSTANCE}:admin:secret" > /etc/koha/passwd

# - koha.createdb

RUN /etc/init.d/mysql start && \
    koha-create --create-db $KOHA_INSTANCE && \
    /etc/init.d/koha-common stop && \
    /etc/init.d/apache2 stop && \ 
    /etc/init.d/mysql stop && \
    sleep 10   

# - koha.config # includes switching to db instance on ls.db

ENV DB_HOST 127.0.0.1

RUN printf "[client]\nhost     = ${DB_HOST}" > /etc/mysql/koha-common.cnf

RUN echo "kohauser:XXX" > /etc/koha/sites/$KOHA_INSTANCE/zebra.passwd
# Skipped:
#    - group: {{ pillar['koha']['instance'] }}-koha
#    - user: {{ pillar['koha']['instance'] }}-koha

ADD files/koha-conf.xml.tmpl /etc/koha/sites/${KOHA_INSTANCE}/koha-conf.xml

RUN sed -e 's/{{ ZebraUser }}/kohauser/g' -i /etc/koha/sites/${KOHA_INSTANCE}/koha-conf.xml && \
    sed -e 's/{{ ZebraPass }}/XXX/g' -i /etc/koha/sites/${KOHA_INSTANCE}/koha-conf.xml && \
    sed -e "s/{{ ServerName }}/$KOHA_INSTANCE/g" -i /etc/koha/sites/${KOHA_INSTANCE}/koha-conf.xml && \
    sed -e "s/{{ HostName }}/${DB_HOST}/g" -i /etc/koha/sites/${KOHA_INSTANCE}/koha-conf.xml

# Skipped:
#    - group: {{ pillar['koha']['instance'] }}-koha
#    - user: {{ pillar['koha']['instance'] }}-koha

# - koha.webinstaller
 
# RUN apt-get -y install make
# RUN perl -MCPAN -e 'install Data::Pagination' &&  \
#     perl -MCPAN -e 'upgrade Archive::Extract' && \
#     perl -MCPAN -e 'upgrade Test::WWW::Mechanize' && \
#     perl -MCPAN -e 'upgrade HTTPD::Bench::ApacheBench'
# RUN mv /etc/koha /etc/kohaDefault && ln -s /koha-data/etc-koha /etc/koha
# RUN mv /var/lib/mysql /var/lib/mysqlDefault && ln -s /koha-data/mysql-data /var/lib/mysql
# 

CMD /etc/init.d/mysql start && /etc/init.d/koha-common start && /usr/sbin/apache2ctl -D FOREGROUND
