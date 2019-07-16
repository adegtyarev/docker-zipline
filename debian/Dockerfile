FROM    python:3.5-slim

ARG     ZIPLINE_REF

ENV     ZIPLINE_REF ${ZIPLINE_REF:-master}

ENV     ZIPLINE_ROOT /zipline

ENV     ZIPLINE_USER zipline

ENV     ZIPLINE_GROUP zipline

ENV     PYTHONUSERBASE /lib/zipline

ENV     PATH $PYTHONUSERBASE/bin:$PATH

RUN     addgroup $ZIPLINE_GROUP && \
        useradd \
            -g $ZIPLINE_GROUP \
            --create-home \
            --home-dir $ZIPLINE_ROOT \
            --shell /sbin/nologin $ZIPLINE_USER && \
        install -v -d -o $ZIPLINE_USER -g $ZIPLINE_GROUP \
            $PYTHONUSERBASE \
            /src && \
        apt update && \
        apt install -y \
            build-essential \
            git && \
        git clone \
            --single-branch \
            --branch $ZIPLINE_REF \
            https://github.com/quantopian/zipline.git /src/zipline.git && \
        cd /src/zipline.git && \
        pip3 install \
            --no-cache-dir \
            --no-compile \
            numpy==1.11.3 && \
        pip3 install \
            --no-cache-dir \
            --no-compile \
            -r etc/requirements.txt && \
        ZIPLINE_SRC=/src/zipline-$(python3 setup.py version |grep ^Version |awk '{print $2}') && \
        mkdir -v \
            $ZIPLINE_SRC && \
        rm -v \
            .gitattributes && \
        git archive \
            --worktree-attributes \
            HEAD |tar -v -C $ZIPLINE_SRC -x && \
        ln -v -s $ZIPLINE_SRC /src/zipline && \
        cd $ZIPLINE_SRC && \
        pip3 install \
            --no-cache-dir \
            --no-compile \
            --editable \
            . && \
        rm -rf \
            build \
            /src/zipline.git && \
        apt purge -y \
            git \
            build-essential && \
        apt autoremove -y && \
        apt clean

USER    $ZIPLINE_USER

WORKDIR /src/zipline

VOLUME  $ZIPLINE_ROOT

CMD     zipline
