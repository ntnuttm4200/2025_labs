FROM ttm4200_base:v1
LABEL maintainer="TTM4200_Staff"
ENV DEBIAN_FRONTEND=noninteractive
COPY ./ /build
RUN cp /build/startup.sh /usr/bin/ && chmod +x /usr/bin/startup.sh
RUN chmod +x /build/*.sh
RUN /build/utilities.sh
RUN cp /build/config_files/etc/nginx/sites-available/ttm4200 /etc/nginx/sites-available/
RUN mkdir -p /var/www/ttm4200
RUN cp /build/config_files/var/www/ttm4200/ttm4200_index.html /var/www/ttm4200/
RUN cp /build/config_files/var/www/ttm4200/info.php /var/www/ttm4200/
RUN cp /build/config_files/var/www/ttm4200/50x.html /var/www/ttm4200/
RUN /build/cleanup.sh
CMD ["/usr/bin/iinit.sh"]





