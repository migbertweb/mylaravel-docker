# Set master image
FROM php:8.1.9-fpm-alpine

# Copy composer.lock and composer.json
COPY composer.lock composer.json /var/www/html/

# Set working directory
WORKDIR /var/www/html

# Install Additional dependencies
RUN apk update && apk add --no-cache \
    build-base shadow vim bash curl autoconf dpkg dpkg-dev pkgconf re2c \
    nodejs-current \
    npm \
    php81 \
    php81-fpm \
    php81-common \
    php81-pdo \
    php81-pdo_mysql \
    php81-mysqli \
    php81-mbstring \
    php81-xml \
    php81-openssl \
    php81-json \
    php81-phar \
    php81-zip \
    php81-gd \
    php81-dom \
    php81-session \
    php81-zlib

# Add and Enable PHP-PDO Extenstions
RUN docker-php-ext-install pdo pdo_mysql
RUN docker-php-ext-enable pdo_mysql

# Install PHP Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN composer update

# Remove Cache
RUN rm -rf /var/cache/apk/*

# Add UID '1000' to www-data
RUN usermod -u 1000 www-data

# Copy existing application directory permissions
COPY --chown=www-data:www-data . /var/www/html

# Change current user to www
USER www-data

# Expose port 9000 and start php-fpm server
EXPOSE 9000
CMD ["php-fpm"]
