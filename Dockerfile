FROM php:8.2-fpm

RUN apt-get update && apt-get install -y \
  build-essential \
  libpng-dev libjpeg62-turbo-dev libfreetype6-dev \
  libonig-dev libxml2-dev libzip-dev zip unzip git curl \
  && docker-php-ext-install pdo_mysql mbstring zip exif pcntl bcmath

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

WORKDIR /var/www
COPY . .

RUN composer install --no-interaction --optimize-autoloader \
  && chown -R www-data:www-data /var/www \
  && chmod -R 755 /var/www/storage

EXPOSE 9000
CMD ["php-fpm"]
