# A collection of Zipline images

- Base Docker image with [Zipline](https://github.com/quantopian/zipline) algorithmic trading library
- Image with Zipline & [TA-lib](http://ta-lib.org/) libraries
- Image for Zipline development
- Research image with dev Zipline & [Jupyter](http://jupyter.org/)


## Software specification

* Base image: [Alpine Linux](https://alpinelinux.org/)
* Python support: 2.7, 3.5

[![Build Status](https://travis-ci.org/adegtyarev/docker-zipline.svg?branch=master)](https://travis-ci.org/adegtyarev/docker-zipline)


Tag     | Layers & size
---     | ---
latest  | ![zipline:python3][python3.svg]
talib   | ![zipline:python3-talib][python3-talib.svg]
dev     | ![zipline:python3-dev][python3-dev.svg]
jupyter | ![zipline:python3-jupyter][python3-jupyter.svg]

[python3.svg]: https://images.microbadger.com/badges/image/adegtyarev/zipline:python3.svg "Image size & number of layers"
[python3-talib.svg]: https://images.microbadger.com/badges/image/adegtyarev/zipline:python3-talib.svg "Image size & number of layers"
[python3-dev.svg]: https://images.microbadger.com/badges/image/adegtyarev/zipline:python3-dev.svg "Image size & number of layers"
[python3-jupyter.svg]: https://images.microbadger.com/badges/image/adegtyarev/zipline:python3-jupyter.svg "Image size & number of layers"


## Quick start

Create a new volume to store permanent data (usually referred to as
`$ZIPLINE_ROOT`):

    docker volume create --name zipline-root

Run `zipline` command in a Docker container:

    docker run --rm --volume zipline-root:/zipline adegtyarev/zipline
    Usage: zipline [OPTIONS] COMMAND [ARGS]...

      Top level zipline entry point.
    ...


## Usage


### Command line tool

This image basically intended to be a drop-in replacement to `zipline` command
in a Docker environment:

    export ZIPLINE_CMD="docker run --rm -t -v zipline:/zipline adegtyarev/zipline zipline"

So that you just replace `zipline` with `$ZIPLINE_CMD`:

    $ZIPLINE_CMD ingest -b quantopian-quandl
    Downloading Bundle: quantopian-quandl  [####################################]  100%
    INFO: ...: Writing data to /zipline/data/quantopian-quandl/2018-01-31T12;27;19.433422.

Run an example trading algorithm:

    $ZIPLINE_CMD run -s 2017-1-1 -e 2018-1-1 -b quantopian-quandl -f zipline/examples/buy_and_hold.py


### Research notebook

The image with `jupyter` tag is ready to start a research with Zipline in a
Jupyter notebook.  You will need a volume to store notebooks permanently:

    docker volume create --name zipline-notes

    docker run --rm -p 80:8888 \
        -v zipline-root:/zipline \
        -v zipline-notes:/notes \
        adegtyarev/zipline:jupyter

This will start a Jupyter HTTP-server with Zipline installed and notes volume
attached to a directory which eventually is a chroot directory for the server.
You can then connect to port 80 using a web browser.


### Secure notebook with HTTPS

It is easy to secure your research environment by using SSL certificates from
[Let's Encrypt](https://letsencrypt.org/).  You will need a new volume to keep
certificates:

    docker volume create --name zipline-certs

Run the following dummy command to attach the new volume with pre-defined
permissions on directories inside /etc/letsencrypt:

    docker run --rm -v zipline-certs:/etc/letsencrypt adegtyarev/zipline:jupyter true

Make sure you have port 80/tcp open to the outside world so that LE could
connect to run a verification procedure.  Use an official image of
`certbot/certbot` to obtain SSL certificate and a key:

    SSL_HOSTNAME=example.com    # Set this to the public domain name
    SSL_EMAIL=$USER@$HOSTNAME   # Email address for important notifications from LE

    docker run --rm -p 80:80 \
        -v zipline-certs:/etc/letsencrypt \
        certbot/certbot certonly --standalone \
        -d $SSL_HOSTNAME --agree-tos -m $SSL_EMAIL --non-interactive

A secured Jupyter notebook should be ready to start now:

    docker run --rm -p 443:8888 \
        -e SSL_HOSTNAME=$SSL_HOSTNAME \
        -v zipline-root:/zipline \
        -v zipline-notes:/notes \
        -v zipline-certs:/etc/letsencrypt \
        adegtyarev/zipline:jupyter notebook-ssl

Note that a port to open in a browser has changed from 80 (HTTP) to 443
(HTTPS).


### Using as a base image

The image may also be used as a base Docker image for Zipline-related tools:

```Dockerfile
    FROM    adegtyarev/zipline:latest

    COPY    --chown=zipline:zipline . /src/zipline-cool-feature

    RUN     cd /src/zipline-cool-feature && \
            pip3 install \
                --no-cache-dir \
                --user \
                -r requirements.txt && \
            pip3 install \
                --no-cache-dir \
                --user \
                --editable \
                .

    ...     # continue with zipline & cool feature installed
```


## Author

Alexey Degtyarev <alexey@renatasystems.org>
