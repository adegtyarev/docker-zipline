FROM    adegtyarev/zipline:python3-talib

USER    root

RUN     apk add --no-cache --virtual .build-deps \
            build-base \
            freetype-dev \
            git \
            libpng-dev \
            linux-headers \
            python3-dev && \
        pip3 install \
            --no-cache-dir \
            --no-compile \
            -r etc/requirements_blaze.txt \
            -r etc/requirements_dev.txt && \
        rm -rf \
            src && \
        apk del --no-cache \
            .build-deps && \
        apk add --no-cache \
            freetype

USER    $ZIPLINE_USER
