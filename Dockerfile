#------------------ development ----------------#
# Dockerfile

FROM php:7.4-cli as development

ENV TZ=America/Sao_Paulo
RUN ln -snf /usr/share/zoneinfo/${TZ} /etc/localtime && echo ${TZ} > /etc/timezone

RUN curl -sL https://deb.nodesource.com/setup_12.x | bash - 

ARG user=projetoroot
ARG uid=1000

RUN apt-get install wget -y

RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ `lsb_release -cs`-pgdg main" | tee  /etc/apt/sources.list.d/pgdg.list

RUN apt-get update && apt-get install -y \
    build-essential \
    libpng-dev \
    libjpeg62-turbo-dev \
    libldap2-dev \
    libfreetype6-dev \
    libpq-dev \
    libzip-dev \
    libonig-dev \
    locales \
    zip \
    jpegoptim optipng pngquant gifsicle \
    vim \
    unzip \
    git \
    curl \
    nodejs \
    graphviz \    
    postgresql-client-12

RUN npm install -g yarn

RUN apt-get clean && rm -rf /var/lib/apt/lists/*

RUN docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu/ \
    &&  docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql \
    && docker-php-ext-install pgsql pdo_pgsql mbstring zip exif pcntl gd ldap

RUN pecl install -o -f redis xdebug-3.1.5 \
    &&  rm -rf /tmp/pear \
    &&  docker-php-ext-enable redis xdebug

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer && composer self-update

RUN echo "xdebug.remote_enable=on" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.remote_handler=dbgp" >>  /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.remote_port=9000" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.remote_autostart=on" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.remote_connect_back=on" >> /usr/local/etc/php/conf.d/xdebug.ini \    
    && echo "xdebug.idekey=VSCODE" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.remote_log=/app/storage/logs/xdebug.log" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.default_enable=on" >> /usr/local/etc/php/conf.d/xdebug.ini

COPY ./docker/php/custom.ini /usr/local/etc/php/conf.d/custom.ini

RUN useradd -G www-data,root -u $uid -d /home/$user $user \
    && mkdir -p /home/$user/.composer \
    && chown -R $user:$user /home/$user

WORKDIR /var/www

EXPOSE 8000

# Comentando o trecho abaixo o usuário será o root
#USER projetoroot

#------------------ production ----------------#
FROM php:7.4-fpm as production

ENV TZ=America/Sao_Paulo
RUN ln -snf /usr/share/zoneinfo/${TZ} /etc/localtime && echo ${TZ} > /etc/timezone

RUN curl -sL https://deb.nodesource.com/setup_12.x | bash - 

WORKDIR /var/www

RUN apt-get install wget -y

RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ `lsb_release -cs`-pgdg main" | tee  /etc/apt/sources.list.d/pgdg.list

RUN apt-get update && apt-get install -y \
    build-essential \
    libpng-dev \
    libjpeg62-turbo-dev \
    libldap2-dev \
    libfreetype6-dev \
    libpq-dev \
    libzip-dev \
    libonig-dev \
    locales \
    zip \
    jpegoptim optipng pngquant gifsicle \
    vim \
    unzip \
    git \
    curl \
    nodejs \
    graphviz \    
    postgresql-client-12

RUN npm install -g yarn

RUN apt-get clean && rm -rf /var/lib/apt/lists/*

RUN docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu/ \
    &&  docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql \
    && docker-php-ext-install pgsql pdo_pgsql mbstring zip exif pcntl gd ldap

RUN pecl install -o -f redis xdebug-3.1.5 \
    &&  rm -rf /tmp/pear \
    &&  docker-php-ext-enable redis xdebug

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer && composer self-update

RUN groupadd -g 1000 www
RUN useradd -u 1000 -ms /bin/bash -g www www

COPY ./docker/php/custom.ini /usr/local/etc/php/conf.d/custom.ini

COPY ./src-candidato/ /var/www/

RUN chown -R www:www-data /var/www/*
RUN chmod -R 775 -R /var/www/*

# Comentando sobe como usuário root
# USER www

EXPOSE 9000
CMD ["php-fpm"]
