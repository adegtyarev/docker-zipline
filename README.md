# docker zipline

A collection of [Zipline](https://github.com/quantopian/zipline) images.

## Software specification

[![Build Status](https://travis-ci.org/adegtyarev/docker-zipline.svg?branch=master)](https://travis-ci.org/adegtyarev/docker-zipline)

* Base image: Alpine

* Python support: 2.7, 3.5

* Images:
    - Base image with Zipline algorithmic trading library
    - Image with Zipline & [TA-lib](http://ta-lib.org/) support
    - Image for Zipline development
    - Research image with dev Zipline & [Jupyter](http://jupyter.org/)

## Quick start

Create a new volume to store permanent data (usually referred to as
`$ZIPLINE_ROOT`):

    docker volume create --name zipline-root

Now you can run `zipline` command in a Docker container:

    docker run --rm --volume zipline-root:/zipline adegtyarev/zipline
    Usage: zipline [OPTIONS] COMMAND [ARGS]...

      Top level zipline entry point.
    ...


## Usage


### Command line tool

This image intended to be a drop-in replacement to `zipline` command in a
Docker environment:

    export ZIPLINE_CMD="docker run --rm -t -v zipline:/zipline adegtyarev/zipline zipline"

So that you'll just replace `zipline` with `$ZIPLINE_CMD`:

    $ZIPLINE_CMD ingest -b quantopian-quandl
    Downloading Bundle: quantopian-quandl  [####################################]  100%
    INFO: ...: Writing data to /zipline/data/quantopian-quandl/2018-01-31T12;27;19.433422.

Run an example trading algorithm:

    $ZIPLINE_CMD run -s 2017-1-1 -e 2018-1-1 -b quantopian-quandl -f zipline/examples/buy_and_hold.py


### Research notebook

The image is ready to start a research with Zipline in a Jupyter notebook.  You
will need a volume to store notebooks permanently:

    docker volume create --name zipline-notes

    docker run --rm -p 80:8888 \
        -v zipline-root:/zipline \
        -v zipline-notes:/notes \
        adegtyarev/zipline:jupyter

This will start on port 80 a Jupyter HTTP-server with Zipline installed and
notes volume attached to `/notes` directory which eventually is a chroot
directory for the server.  You can then connect to using web browser.

### Secure notebook with HTTPS

It is easy to secure your research environment by using SSL certificates from
[Let's Encrypt](https://letsencrypt.org/).  You will need a new volume to keep
certificates:

    docker volume create --name zipline-certs

Make sure you have port 80/tcp open to the outside world so that LE could
connect to run a verification procedure.  Use an official image of
`certbot/certbot` to obtain SSL certificate and a key:

    SSL_HOSTNAME=example.com    # Set this to the public domain name
    SSL_EMAIL=$USER@$HOSTNAME   # Email address for important notifications from LE

    docker run --rm -p 80:80 -v zipline-certs:/etc/letsencrypt certbot/certbot \
        certonly --standalone -d $SSL_HOSTNAME --agree-tos -m $SSL_EMAIL --non-interactive

Then a secured Jupyter notebook should be ready to run:

    docker run --rm -p 443:8888 \
        -e SSL_HOSTNAME=$SSL_HOSTNAME \
        -v zipline-root:/zipline \
        -v zipline-notes:/notes \
        -v zipline-certs:/etc/letsencrypt \
        adegtyarev/zipline:jupyter notebook-ssl


### Using as base image

The image can also be used as a base image for Zipline-related tools:

    FROM    adegtyarev/zipline:latest
    RUN     ... # continue with zipline installed


## Author

Alexey Degtyarev <alexey@renatasystems.org>
