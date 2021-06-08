FROM php:7.4-fpm-alpine

# Prepare project directory
RUN mkdir -p /var/www/html && adduser www-data root
COPY . /var/www/html/

# Install packages
RUN apk update && apk --no-cache add py-pip coreutils bash supervisor nginx curl unzip git ffmpeg tzdata \
  freetype libpng libwebp-dev libjpeg-turbo freetype-dev libpng-dev libjpeg-turbo-dev libonig-dev libzip-dev zlib-dev && \
  cp /usr/share/zoneinfo/Asia/Jakarta /etc/localtime && echo "Asia/Jakarta" > /etc/timezone && apk del tzdata && \
  curl -sS https://getcomposer.org/installer | php && mv composer.phar /usr/local/bin/composer && \
  docker-php-ext-configure gd \
    --with-freetype=/usr/include/ \
#    --with-png=/usr/include/ \
    --with-jpeg=/usr/include/ && \
  NPROC=$(grep -c ^processor /proc/cpuinfo 2>/dev/null || 1) && \
  docker-php-ext-install -j${NPROC} gd && \
  docker-php-ext-install pdo_mysql mbstring zip && \
  mkdir /var/log/php-fpm
