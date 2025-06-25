# Stage 1: Base PHP
FROM php:8.3-fpm

# Install system dependencies & PHP extensions
RUN apt-get update && apt-get install -y \
    git curl zip unzip libpng-dev libonig-dev libxml2-dev libzip-dev \
    libcurl4-openssl-dev pkg-config libssl-dev gnupg ca-certificates wget gnupg2 \
    && docker-php-ext-install pdo pdo_mysql mbstring bcmath fileinfo zip \
    && apt-get clean

# Install Node.js 20 & npm
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs \
    && node -v && npm -v

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /var/www

# Copy all source code
COPY . .

# Install Laravel dependencies & build frontend
RUN composer install --no-dev --optimize-autoloader \
 && npm ci \
 && npm run build

# Set permissions for Laravel
RUN chown -R www-data:www-data /var/www \
 && chmod -R 775 storage bootstrap/cache
