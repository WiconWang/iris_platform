FROM php:7.4.1-cli

ENV DEBIAN_FRONTEND noninteractive
ENV TERM xterm-color

ARG DEV_MODE
ENV DEV_MODE $DEV_MODE

COPY ./Dockerfiles/ /

RUN \
 php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
 php composer-setup.php --install-dir="/usr/bin" --filename=composer && \
 chmod +x "/usr/bin/composer" && \
 composer self-update 1.9.2

RUN mv /etc/apt/sources.list /etc/apt/sources.list.bak && \
    echo "deb http://mirrors.163.com/debian/ buster/main buster main non-free contrib" >/etc/apt/sources.list && \
    echo "deb http://mirrors.163.com/debian/ buster/main buster-proposed-updates main non-free contrib" >>/etc/apt/sources.list && \
    echo "deb-src http://mirrors.163.com/debian/ buster/main buster main non-free contrib" >>/etc/apt/sources.list && \
    echo "deb-src http://mirrors.163.com/debian/ buster/main buster-proposed-updates main non-free contrib" >>/etc/apt/sources.list 

RUN  apt-get update && apt-get install -y \
 libssl-dev \
 supervisor \
 unzip \
 zlib1g-dev \
 --no-install-recommends

RUN install-swoole.sh 4.4.15 && \
 mkdir -p /var/log/supervisor && \
 rm -rf /var/lib/apt/lists/* /usr/bin/qemu-*-static

ENTRYPOINT ["/entrypoint.sh"]
CMD []

WORKDIR "/var/www/"
