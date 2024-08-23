# Use the official PHP 8.1 FPM image
FROM php:8.1.29-fpm

# Set working directory
WORKDIR /var/www

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip \
    && docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

# Install Composer
COPY --from=composer:2.7.7 /usr/bin/composer /usr/bin/composer

# Copy project files to /src
COPY . /var/www

RUN chown -R www-data:www-data /var/www \
    && chmod -R 755 /var/www/storage \
    && chmod -R 755 /var/www/bootstrap

# Install project dependencies
RUN composer install --optimize-autoloader --no-dev

# Copy custom PHP-FPM configuration
COPY ./custom-php-fpm.conf /usr/local/etc/php-fpm.d/www.conf

# Expose the port that the PHP server will run on
EXPOSE 9095

# Start the PHP server
CMD ["php", "-S", "0.0.0.0:9095", "public/index.php"]

