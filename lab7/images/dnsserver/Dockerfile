FROM ttm4200_base:v1
LABEL maintainer="TTM4200_Staff"
ENV DEBIAN_FRONTEND=noninteractive
COPY ./ /build
RUN chmod +x /build/*.sh
RUN /build/utilities.sh
RUN cp /build/startup.sh /usr/bin/ && chmod +x /usr/bin/startup.sh
RUN cp /build/config_files/etc/bind/named.conf.local /etc/bind/
RUN cp /build/config_files/etc/bind/named.conf.options /etc/bind/
RUN cp /build/config_files/etc/bind/rev-ttm4200.com.zone /etc/bind/
RUN cp /build/config_files/etc/bind/ttm4200.com.zone /etc/bind/
RUN /build/cleanup.sh
CMD ["/usr/bin/iinit.sh"]





