FROM php:8.2-fpm

# Install dependencies and Nginx
RUN apt-get update && apt-get install -y \
    zip unzip curl git libpng-dev libonig-dev libxml2-dev nginx \
    && docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /var/www

# Copy Laravel files
COPY backend /var/www

# Install dependencies
RUN cd /var/www && composer install --no-dev --optimize-autoloader

# Set permissions
RUN chown -R www-data:www-data /var/www \
    && chmod -R 775 /var/www/storage /var/www/bootstrap/cache

# Copy Nginx configuration
COPY nginx/default.conf /etc/nginx/sites-available/default
RUN ln -sf /etc/nginx/sites-available/default /etc/nginx/sites-enabled/

# Create start script to handle Heroku's dynamic port
RUN echo '#!/bin/bash\n\
sed -i "s/listen \$PORT/listen $PORT/g" /etc/nginx/sites-available/default\n\
php-fpm -D\n\
nginx -g "daemon off;"\n\
' > /start.sh && chmod +x /start.sh

# Expose port
EXPOSE 80

# Start script as CMD
CMD ["/start.sh"]