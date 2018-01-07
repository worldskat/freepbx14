#!/bin/bash
a2enmod rewrite
service apache2 start
service mysql start
fwconsole start
service cron start
tail -f /var/log/asterisk/freepbx.log & wait $!

