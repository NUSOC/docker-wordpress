FROM wordpress:php7.4-apache
RUN mkdir /var/www/wordpress \
&& mkdir /var/www/wordpress/wp-content \
&& mkdir /var/www/wordpress/wp-content/plugins \
&& mkdir /var/www/wordpress/wp-content/themes \
&& mkdir /var/www/wordpress/wp-content/uploads \
&& mkdir /var/www/wordpress/wp-content/cache \
&& chown -R www-data:www-data /var/www \
&& curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
&& chmod +x wp-cli.phar \
&& mv wp-cli.phar /usr/local/bin/wp \
&& a2enmod headers \
&& sed -i 's/KeepAlive Off/KeepAlive On/g' /etc/apache2/apache2.conf
COPY config/.htaccess /var/www/wordpress/.htaccess
COPY config/000-default.conf /etc/apache2/sites-available/000-default.conf
COPY config/opcache-recommended.ini /usr/local/etc/php/conf.d/opcache-recommended.ini
COPY config/mpm_prefork.conf /etc/apache2/mods-available/mpm_prefork.conf
COPY config/robots.txt /var/www/wordpress/robots.txt
WORKDIR /var/www/wordpress
