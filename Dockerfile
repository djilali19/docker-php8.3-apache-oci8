FROM php:8.3-apache

RUN apt-get update \
    && apt-get install -y libaio-dev unzip vim wget \
    && rm -rf /var/lib/apt/lists/*

RUN wget https://download.oracle.com/otn_software/linux/instantclient/213000/instantclient-basic-linux.x64-21.3.0.0.0.zip \
    && wget https://download.oracle.com/otn_software/linux/instantclient/213000/instantclient-sdk-linux.x64-21.3.0.0.0.zip \
    && unzip instantclient-basic-linux.x64-21.3.0.0.0.zip -d /usr/local/ \
    && unzip instantclient-sdk-linux.x64-21.3.0.0.0.zip -d /usr/local/ \
    && ln -s /usr/local/instantclient_21_3 /usr/local/instantclient \
    && ln -s /usr/local/instantclient/lib* /usr/lib \
    && ln -s /usr/local/instantclient/sqlplus /usr/bin/sqlplus \
    && rm instantclient-basic-linux.x64-21.3.0.0.0.zip instantclient-sdk-linux.x64-21.3.0.0.0.zip

RUN docker-php-ext-configure oci8 --with-oci8=instantclient,/usr/local/instantclient \
    && docker-php-ext-install oci8

RUN a2enmod rewrite ssl \
    && service apache2 restart
