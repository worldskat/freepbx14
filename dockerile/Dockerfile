FROM debian
MAINTAINER Boris Berezovskiy <worldskat@gmail.com>
RUN echo "deb http://deb.debian.org/debian jessie main" >> /etc/apt/sources.list
RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y build-essential linux-headers-`uname -r` openssh-server apache2 mysql-server  mysql-client mongodb bison flex php5 php5-curl php5-cli php5-mysql php-pear php5-gd curl sox  libncurses5-dev libssl-dev libmysqlclient-dev mpg123 libxml2-dev libnewt-dev sqlite3  libsqlite3-dev pkg-config automake libtool autoconf git unixodbc-dev uuid uuid-dev  libasound2-dev libogg-dev libvorbis-dev libicu-dev libcurl4-openssl-dev libical-dev libneon27-dev libsrtp0-dev  libspandsp-dev sudo libmyodbc subversion libtool-bin python-dev
RUN curl -sL https://deb.nodesource.com/setup_8.x |bash -
RUN apt-get install wget 
RUN cd /usr/src && wget http://downloads.asterisk.org/pub/telephony/libpri/libpri-current.tar.gz && wget http://downloads.asterisk.org/pub/telephony/asterisk/asterisk-13-current.tar.gz &&  wget -O jansson.tar.gz https://github.com/akheron/jansson/archive/v2.7.tar.gz
WORKDIR /usr/src
RUN  tar vxfz jansson.tar.gz && rm -f jansson.tar.gz && cd jansson-* && autoreconf -i &&  ./configure && make && make install
RUN tar xvfz asterisk-13-current.tar.gz && rm -f asterisk-13-current.tar.gz 
WORKDIR /usr/src/asterisk-13.18.5
RUN contrib/scripts/get_mp3_source.sh
RUN apt-get install aptitude -y
ENV DEBIAN_FRONTEND noninteractive
RUN contrib/scripts/install_prereq  install 
RUN ./configure --with-pjproject-bundled
COPY menuselect.makeopts /usr/src/asterisk-13.18.5
#RUN make menuselect
RUN make
RUN make install
RUN make config 
RUN ldconfig 
RUN "/bin/bash" "-c" "update-rc.d -f asterisk remove && useradd -m asterisk && chown asterisk. /var/run/asterisk  && chown -R asterisk.  /etc/asterisk && chown -R asterisk. /var/{lib,log,spool}/asterisk && chown -R asterisk. /usr/lib/asterisk && rm -rf /var/www/html && sed -i 's/\(^upload_max_filesize = \).*/\120M/' /etc/php5/apache2/php.ini  && cp /etc/apache2/apache2.conf /etc/apache2/apache2.conf_orig  && sed -i 's/^\(User\|Group\).*/\1 asterisk/' /etc/apache2/apache2.conf  && sed -i 's/AllowOverride None/AllowOverride All/' /etc/apache2/apache2.conf  &&  service apache2 restart"
COPY odbcinst.ini /etc/odbcinst.ini
WORKDIR /usr/src/
RUN wget http://mirror.freepbx.org/modules/packages/freepbx/freepbx-14.0-latest.tgz  && tar vxfz freepbx-14.0-latest.tgz  && rm -f freepbx-14.0-latest.tgz  && cd freepbx && touch /etc/asterisk/ari.conf && ./start_asterisk start &&   apt-get install php-mysql -y 
RUN update-alternatives --set php /usr/bin/php5 
RUN cd freepbx && ./start_asterisk start && service mysql start  && ./install -n
COPY entrypoint.sh /
RUN apt-get install cron ffmpeg -y
ENTRYPOINT /entrypoint.sh
