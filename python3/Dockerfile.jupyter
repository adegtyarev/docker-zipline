FROM    adegtyarev/zipline:python3-dev

USER    root

RUN     apk add --no-cache --virtual .build-deps \
            build-base \
            python3-dev && \
        pip3 install \
            --no-cache-dir \
            --no-compile \
            jupyter && \
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

CMD     ["notebook"]
