FROM    adegtyarev/zipline:python2

ARG     TALIB_REF

ENV     TALIB_REF ${TALIB_REF:-0.4.0}

USER    root

RUN     apk add --no-cache --virtual .build-deps \
            build-base \
            ca-certificates \
            curl \
            file \
            py-pip \
            python2-dev && \
        curl -s -L -o /src/ta-lib-src.tar.gz \
            https://downloads.sourceforge.net/project/ta-lib/ta-lib/$TALIB_REF/ta-lib-$TALIB_REF-src.tar.gz && \
        tar -C /src -vxzf /src/ta-lib-src.tar.gz && \
        cd /src/ta-lib && \
        ./configure --prefix=/usr && \
        (make -j$(getconf _NPROCESSORS_ONLN) || make ) && \
        make install && \
        cd .. && \
        rm -r ta-lib ta-lib-src.tar.gz && \
        pip install \
            --no-cache-dir \
            --no-compile \
            -r /src/zipline/etc/requirements_talib.txt && \
        apk del --no-cache \
            .build-deps

USER    $ZIPLINE_USER
