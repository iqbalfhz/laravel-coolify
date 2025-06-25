# Stage 1: Base PHP
FROM php:8.3-fpm

# Install system dependencies & PHP extensions
RUN apt-get update && apt-get install -y \
    git curl zip unzip libpng-dev libonig-dev libxml2-dev libzip-dev \
    libcurl4-openssl-dev pkg-config libssl-dev gnupg ca-certificates \
    wget gnupg2 && \
    docker-php-ext-install pdo pdo_mysql mbstring bcmath fileinfo zip

# Install Node.js & npm (via NodeSource)
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs \
    && node -v && npm -v

# Install Composer (stage copy)
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /var/www

# Copy all files
COPY . .

# Install dependencies (can also be run manually in container if needed)
RUN composer install --no-dev --optimize-autoloader \
 && npm ci && npm run build

# Permissions for Laravel
RUN chmod -R ug+w storage bootstrap/cache
