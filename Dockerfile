FROM openresty/openresty:latest
RUN mkdir -p /usr/local/openresty/nginx/lua
ADD content.lua /usr/local/openresty/nginx/lua
ADD access.lua /usr/local/openresty/nginx/lua
ADD header.lua /usr/local/openresty/nginx/lua
ADD nginx.conf /usr/local/openresty/nginx/conf/nginx.conf
EXPOSE 80