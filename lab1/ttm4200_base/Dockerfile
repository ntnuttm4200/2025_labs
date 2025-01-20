FROM ubuntu:24.04

LABEL maintainer="TTM4200_Staff"

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/Oslo
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

ARG USER_ID=1003
ARG GROUP_ID=1003
ARG USER_NAME=ttm4200
ARG GROUP_NAME=ttm4200

RUN if [ ${USER_ID:-0} -ne 0 ] && [ ${GROUP_ID:-0} -ne 0 ]; then \ 
    groupadd -g ${GROUP_ID} ${GROUP_NAME} &&\
    useradd -l -s /bin/bash -u ${USER_ID} -g ${GROUP_NAME} -G sudo ${USER_NAME} &&\
    install -d -m 0755 -o ${USER_NAME} -g ${GROUP_NAME} /home/${USER_NAME} \
    ;fi

RUN groupadd -g 13401 eall_s && \
    usermod -aG eall_s ttm4200

COPY ./ /build
RUN cp /build/iinit.sh /usr/bin/ && chmod +x /usr/bin/iinit.sh
RUN chmod +x /build/*.sh
RUN /build/utilities.sh && /build/cleanup.sh
WORKDIR /home/${USER_NAME}
CMD ["/usr/bin/iinit.sh"]
