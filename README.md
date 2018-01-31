# docker zipline

A Docker image for [Zipline](https://github.com/quantopian/zipline), a Pythonic algorithmic
trading library


## Software specification

* Base image: Alpine

* Python support: 2.7, 3.5

* Image size (compressed): ~230MB

* Exported volume: /zipline

* Required Docker (any):
  - Docker Engine 1.10 and higher
  - Docker CE 17.03 and higher


## Quick start

Create a new volume to store permanent data (usually referred to as
`$ZIPLINE_ROOT`):

    docker volume create --name zipline

Now you can run `zipline` command in a Docker container:

    docker run --rm --volume zipline:/zipline adegtyarev/zipline
    Usage: zipline [OPTIONS] COMMAND [ARGS]...

      Top level zipline entry point.
    ...


## Usage

This image intended to be a drop-in replacement to `zipline` command in a
Docker environment:

    export ZIPLINE_CMD="docker run --rm -t -v zipline:/zipline adegtyarev/zipline zipline"

So that you'll just replace `zipline` with `$ZIPLINE_CMD`:

    $ZIPLINE_CMD ingest -b quantopian-quandl
    Downloading Bundle: quantopian-quandl  [####################################]  100%
    INFO: ...: Writing data to /zipline/data/quantopian-quandl/2018-01-31T12;27;19.433422.

Run an example trading algorithm:

    $ZIPLINE_CMD run -s 2017-1-1 -e 2018-1-1 -b quantopian-quandl -f zipline/examples/buy_and_hold.py


The image can also be used as a base image for Zipline-related tools:

    FROM    adegtyarev/zipline:latest
    ADD     ... # continue with zipline installed


## Author

Alexey Degtyarev <alexey@renatasystems.org>
