FROM    adegtyarev/zipline:python2-dev

USER    root

RUN     apk add --no-cache --virtual .build-deps \
            build-base \
            linux-headers \
            python2-dev \
            zeromq-dev && \
        pip install --no-cache-dir --no-compile \
            jupyterlab && \
        apk del --no-cache \
            .build-deps && \
        install -v -d -o $ZIPLINE_USER -g $ZIPLINE_GROUP \
            /etc/letsencrypt/live \
            /etc/letsencrypt/archive \
            /notes

COPY    docker-entrypoint.sh /bin/

USER    $ZIPLINE_USER

WORKDIR /notes

VOLUME  ["$ZIPLINE_ROOT", "/notes", "/etc/letsencrypt"]

ENTRYPOINT ["docker-entrypoint.sh"]

CMD     ["lab"]

EXPOSE  8888
