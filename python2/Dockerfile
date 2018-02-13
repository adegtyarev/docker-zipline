FROM    alpine:latest

ENV     ZIPLINE_REF master

RUN     apk add --no-cache --virtual .build-deps \
            build-base \
            ca-certificates \
            gfortran \
            openblas-dev \
            py-pip \
            python2-dev

RUN     apk add --no-cache --virtual .hdf5-dev \
            --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing/ \
            hdf5-dev

RUN     ln -s /usr/include/locale.h /usr/include/xlocale.h

WORKDIR /src

ADD     https://github.com/quantopian/zipline/archive/$ZIPLINE_REF.tar.gz \
            zipline.tar.gz

RUN     tar -vxzf zipline.tar.gz && \
            mv -v zipline-$ZIPLINE_REF zipline && \
            rm -v zipline.tar.gz

WORKDIR /src/zipline

RUN     pip install -v --no-cache-dir -r etc/requirements.txt

RUN     pip install -v --no-cache-dir -e .

RUN     apk del --no-cache .build-deps .hdf5-dev

RUN     apk add --no-cache openblas libstdc++ py-pip python2

RUN     apk add --no-cache \
            --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing/ \
            hdf5

ENV     ZIPLINE_ROOT /zipline

RUN     addgroup zipline && \
            adduser -D -h $ZIPLINE_ROOT -s /sbin/nologin -G zipline zipline

USER    zipline

VOLUME  $ZIPLINE_ROOT

CMD     zipline
