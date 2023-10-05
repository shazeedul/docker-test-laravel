# Use an official PHP 8.1 Apache image
FROM php:8.1-apache

# Install system dependencies
RUN apt-get update && \
    apt-get install -y libpng-dev libjpeg-dev libfreetype6-dev zip unzip && \
    docker-php-ext-configure gd --with-freetype --with-jpeg && \
    docker-php-ext-install gd pdo pdo_mysql

# Set the working directory inside the container
WORKDIR /var/www/html

# Copy the Laravel application files to the container
COPY . .

# Install Composer globally
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install Laravel dependencies
RUN composer install

# Set up Apache virtual host
COPY docker/vhost.conf /etc/apache2/sites-available/000-default.conf

# Enable Apache modules
RUN a2enmod rewrite

# Expose port 80
EXPOSE 80

# Start Apache
CMD ["apache2-foreground"]

# docker build -t laravel-app .
