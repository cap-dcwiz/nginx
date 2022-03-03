FROM debian:11 as build

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

RUN apt update && apt upgrade -y

RUN wget -O - http://nginx.org/download/nginx-1.17.8.tar.gz | tar -zxf - --strip-components 1
RUN wget -O - https://github.com/vision5/ngx_devel_kit/archive/v0.3.1.tar.gz | tar -zxf -
RUN wget -O - https://github.com/openresty/set-misc-nginx-module/archive/v0.32.tar.gz | tar -zxf -
RUN wget -O - https://github.com/openresty/headers-more-nginx-module/archive/v0.33.tar.gz | tar -zxf -
RUN wget -O - https://github.com/openresty/headers-more-nginx-module/archive/v0.33.tar.gz | tar -zxvf -

RUN ls set-misc-nginx-module-0.32
RUN ./configure --with-cc-opt='-g -O2 -fstack-protector-strong -Wformat -Werror=format-security -fPIC -Wdate-time -D_FORTIFY_SOURCE=2' \
    --with-ld-opt='-Wl,-z,relro -Wl,-z,now -fPIC' \
    --prefix=/usr/share/nginx --conf-path=/etc/nginx/nginx.conf --http-log-path=/var/log/nginx/access.log --error-log-path=/var/log/nginx/error.log --lock-path=/var/lock/nginx.lock --pid-path=/run/nginx.pid --modules-path=/usr/lib/nginx/modules --with-debug --with-pcre-jit --with-http_ssl_module --with-http_stub_status_module --with-http_realip_module --with-http_auth_request_module --with-http_v2_module --with-http_dav_module --with-http_slice_module --with-threads --with-http_addition_module --with-http_gunzip_module --with-http_gzip_static_module --with-http_sub_module --with-http_xslt_module=dynamic --with-stream=dynamic --with-stream_ssl_module --with-stream_ssl_preread_module --with-mail=dynamic --with-mail_ssl_module \
    --with-http_ssl_module \
    --add-dynamic-module=./ngx_devel_kit-0.3.1 \
    --add-dynamic-module=./headers-more-nginx-module-0.33 \
    --add-dynamic-module=./set-misc-nginx-module-0.32 \
    && make && make install



#FROM nginx:1.13.6

#COPY --from=build /opt/nginx/objs/*.so /usr/lib/nginx/modules/
