FROM    adegtyarev/zipline:python3-dev

USER    root

RUN     apk add --no-cache --virtual .build-deps \
            build-base \
            libxml2-dev \
            libxslt-dev \
            linux-headers \
            python3-dev && \
        apk add --no-cache \
            zeromq-dev && \
        pip3 install --no-cache-dir --no-compile \
            jupyter \
            jupyter_contrib_nbextensions \
            jupyter_nbextensions_configurator && \
        pip3 install --upgrade six && \
        apk del --no-cache \
            .build-deps && \
        install -v -d -o $ZIPLINE_USER -g $ZIPLINE_GROUP \
            /etc/letsencrypt/live \
            /etc/letsencrypt/archive \
            /notes && \
        jupyter contrib \
            nbextension install --sys-prefix && \
        jupyter nbextensions_configurator \
            enable --sys-prefix

COPY    docker-entrypoint.sh /bin/

USER    $ZIPLINE_USER

WORKDIR /notes

VOLUME  ["$ZIPLINE_ROOT", "/notes", "/etc/letsencrypt"]

ENTRYPOINT ["docker-entrypoint.sh"]

CMD     ["notebook"]

EXPOSE  8888
