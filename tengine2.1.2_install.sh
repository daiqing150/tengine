#!/bin/bash
#Install needed Software
yum install jemalloc-devel pcre-devel  openssl-devel gcc gcc-c++ -y

#Add service user
useradd www -s /sbin/nologin -M

#unzip software
tar xf ngx_cache_purge-2.3.tar.gz
tar xf LuaJIT-2.1.0-beta2.tar.gz
tar xf tengine-2.1.2.tar.gz
unzip nginx_tcp_proxy_module.zip
unzip headers-more-nginx-module-master.zip

#Install LuaJIT
cd LuaJIT-2.1.0-beta2
make
make install PREFIX=/usr/local/include/luajit-2.1/
ln -s /usr/local/include/luajit-2.1/lib/libluajit-5.1.so.2 /lib64/libluajit-5.1.so.2

#Install Tengine
cd tengine-2.1.2
patch -p1 < ../nginx_tcp_proxy_module-master/tcp.patch

./configure --prefix=/usr/local/tengine --user=www --group=www --with-http_stub_status_module \
--with-http_spdy_module --with-http_ssl_module --with-ipv6 --with-http_gzip_static_module \
--with-http_realip_module --with-http_flv_module --with-http_concat_module=shared \
--with-http_sysguard_module=shared --with-jemalloc \
--add-module=../nginx_tcp_proxy_module-master \
--add-module=../ngx_cache_purge-2.3 \
--add-module=../headers-more-nginx-module-master \
--with-http_lua_module=shared --with-luajit-lib=/usr/local/include/luajit-2.1/lib/ \
--with-luajit-inc=/usr/local/include/luajit-2.1/include/luajit-2.1/  \
--with-ld-opt=-Wl,-rpath,/usr/local/lib
make
make install
