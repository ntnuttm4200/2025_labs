FROM ttm4200_base:v1
LABEL maintainer="TTM4200_Staff"
ENV DEBIAN_FRONTEND=noninteractive
COPY ./ /build
RUN cp /build/startup.sh /usr/bin/ && chmod +x /usr/bin/startup.sh
RUN chmod +x /build/*.sh
RUN /build/utilities.sh
RUN cp /build/config_files/frr.conf /etc/frr/
RUN cp /build/config_files/nftables.conf /etc/
RUN /build/cleanup.sh
CMD ["/usr/bin/iinit.sh"]





