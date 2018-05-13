FROM    alpine:latest

ARG     ZIPLINE_REF

ENV     ZIPLINE_REF ${ZIPLINE_REF:-master}

ENV     ZIPLINE_ROOT /zipline

ENV     ZIPLINE_USER zipline

ENV     ZIPLINE_GROUP zipline

ENV     PYTHONUSERBASE /lib/zipline

ENV     PATH $PYTHONUSERBASE/bin:$PATH

RUN     apk add --no-cache --virtual .build-deps \
            build-base \
            ca-certificates \
            curl \
            gfortran \
            git \
            openblas-dev \
            py-pip \
            python2-dev && \
        apk add --no-cache --virtual .hdf5-dev \
            --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing/ \
            hdf5-dev && \
        ln -v -s /usr/include/locale.h /usr/include/xlocale.h && \
        git clone \
            --single-branch \
            --branch $ZIPLINE_REF \
            https://github.com/quantopian/zipline.git /src/zipline.git && \
        cd /src/zipline.git && \
        export NPY_NUM_BUILD_JOBS=$(getconf _NPROCESSORS_ONLN) && \
        pip install \
            --no-cache-dir \
            --no-compile \
            -r etc/requirements.txt && \
        ZIPLINE_SRC=/src/zipline-$(python setup.py version |grep ^Version |awk '{print $2}') && \
        mkdir -v \
            $ZIPLINE_SRC && \
        rm -v \
            .gitattributes && \
        git archive \
            --worktree-attributes \
            HEAD |tar -v -C $ZIPLINE_SRC -x && \
        ln -v -s $ZIPLINE_SRC /src/zipline && \
        cd $ZIPLINE_SRC && \
        pip install \
            --no-cache-dir \
            --no-compile \
            --editable \
            . && \
        rm -rf \
            build \
            /src/zipline.git && \
        addgroup $ZIPLINE_GROUP && \
        adduser \
            -D \
            -G $ZIPLINE_GROUP \
            -h $ZIPLINE_ROOT \
            -s /sbin/nologin \
            $ZIPLINE_USER && \
        chown -R $ZIPLINE_USER:$ZIPLINE_GROUP \
            /src && \
        install -v -d -o $ZIPLINE_USER -g $ZIPLINE_GROUP \
            $PYTHONUSERBASE && \
        apk del --no-cache \
            .build-deps \
            .hdf5-dev && \
        apk add --no-cache \
            ca-certificates \
            libstdc++ \
            openblas \
            py-pip \
            python2 && \
        apk add --no-cache \
            --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing/ \
            hdf5

USER    $ZIPLINE_USER

WORKDIR /src/zipline

VOLUME  $ZIPLINE_ROOT

CMD     zipline
