FROM ttm4200_webserver:v1
LABEL maintainer="TTM4200_Staff"
ENV DEBIAN_FRONTEND=noninteractive
COPY ./ /build
RUN cp /build/iinit.sh /usr/bin/ && chmod +x /usr/bin/iinit.sh
RUN chmod +x /build/*.sh
RUN /build/utilities.sh && /build/cleanup.sh
CMD ["/usr/bin/iinit.sh"]





