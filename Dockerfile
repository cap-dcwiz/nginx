FROM debian:10 as build

WORKDIR /opt/nginx

RUN apt-get update && \
    apt-get install -y \
        wget \
        libxml2 \
        libxslt1-dev \
        libpcre3 \
        libpcre3-dev \
        zlib1g \
        zlib1g-dev \
        openssl \
        libssl-dev \
        libtool \
        automake \
        gcc \
        g++ \
        make && \
    rm -rf /var/cache/apt

RUN wget -O - http://nginx.org/download/nginx-1.13.6.tar.gz | tar -zxf - --strip-components 1
RUN wget -O - https://github.com/vision5/ngx_devel_kit/archive/v0.3.1.tar.gz | tar -zxf -
RUN wget -O - https://github.com/openresty/set-misc-nginx-module/archive/v0.32.tar.gz | tar -zxf -
RUN wget -O - https://github.com/openresty/headers-more-nginx-module/archive/v0.33.tar.gz | tar -zxf -
RUN wget -O - https://github.com/openresty/headers-more-nginx-module/archive/v0.33.tar.gz | tar -zxvf -

RUN ls set-misc-nginx-module-0.32
RUN ./configure --with-compat \
    --prefix=/usr/share/nginx \
    --with-http_ssl_module \
    --add-dynamic-module=./ngx_devel_kit-0.3.1 \
    --add-dynamic-module=./headers-more-nginx-module-0.33 \
    --add-dynamic-module=./set-misc-nginx-module-0.32 \
    && make modules

FROM nginx:1.13.6
COPY --from=build /opt/nginx/objs/*.so /usr/lib/nginx/modules/
