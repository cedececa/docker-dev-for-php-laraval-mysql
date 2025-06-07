FROM php:8.1-cli

RUN apt-get update && apt-get install -y \
    git \
    curl \
    libzip-dev \
    zip \
    unzip

RUN docker-php-ext-install pdo_mysql zip pcntl

# 安装 Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# 安装 Laravel WebSockets
WORKDIR /var/www/html
RUN composer require beyondcode/laravel-websockets

CMD ["php", "artisan", "websockets:serve"]