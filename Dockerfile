FROM wordpress:php7.3-apache
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
&& a2enmod headers
RUN yes 'no' | pecl install redis \
&& echo extension=redis.so > /usr/local/etc/php/conf.d/redis.ini \
&& ln -s /var/www/wordpress/wp-content/plugins/redis-cache/includes/object-cache.php /var/www/wordpress/wp-content/object-cache.php \
&& ln -s /var/www/wordpress/wp-content/plugins/wordpress-mu-domain-mapping/sunrise.php  /var/www/wordpress/wp-content/sunrise.php \
&& chown -R www-data:www-data /var/www/wordpress
COPY config/.htaccess /var/www/wordpress/.htaccess
COPY config/000-default.conf /etc/apache2/sites-available/000-default.conf
COPY config/opcache-recommended.ini /usr/local/etc/php/conf.d/opcache-recommended.ini
RUN sed -i '/exec/i chown -R www-data:www-data /var/www/wordpress/wp-content/wflogs' /usr/local/bin/docker-entrypoint.sh
WORKDIR /var/www/wordpress