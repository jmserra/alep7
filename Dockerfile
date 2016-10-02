FROM alpine:edge

RUN apk upgrade -U && \
    apk --update --repository=http://dl-4.alpinelinux.org/alpine/edge/testing add \
    openssl \
    php7 \
    php7-xml \
    php7-xsl \
    php7-pdo \
    php7-pdo_mysql \
    php7-mcrypt \
    php7-curl \
    php7-json \
    php7-fpm \
    php7-phar \
    php7-openssl \
    php7-mysqli \
    php7-ctype \
    php7-opcache \
    php7-mbstring \
    php7-session \
    php7-pdo_sqlite \
    php7-sqlite3 \
    php7-pcntl \
    nginx \
    curl \
    supervisor \
  && rm -rf /var/cache/apk/*

# install composer
RUN curl -sS https://getcomposer.org/installer | php7 -- --install-dir=/usr/bin --filename=composer

RUN mkdir -p /etc/nginx
RUN mkdir -p /var/run/php-fpm7
RUN mkdir -p /var/log/supervisor
RUN mkdir -p /run/nginx

RUN rm /etc/nginx/nginx.conf
ADD nginx.conf /etc/nginx/nginx.conf
ADD www.conf /etc/php7/php-fpm.d/www.conf
ADD nginx-default.conf /etc/nginx/sites-enabled/default
ADD php.ini /etc/php7/conf.d/myphp.ini

# Attach nginx logging to Docker logs
RUN ln -sf /dev/stdout /var/log/nginx/access.log && \
ln -sf /dev/stdout /var/log/nginx/error.log

VOLUME ["/var/www"]

ADD nginx-supervisor.ini /etc/supervisor.d/nginx-supervisor.ini

EXPOSE 80 9000

CMD ["/usr/bin/supervisord"]

