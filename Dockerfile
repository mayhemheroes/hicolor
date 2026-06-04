FROM --platform=linux/amd64 ubuntu:20.04 as builder

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
        build-essential \
        pkg-config \
        libpng-dev \
        zlib1g-dev

ADD . /hicolor
WORKDIR /hicolor
RUN make -j8

RUN mkdir -p /deps
RUN ldd /hicolor/hicolor | tr -s '[:blank:]' '\n' | grep '^/' | xargs -I % sh -c 'cp % /deps;'

FROM ubuntu:20.04 as package

COPY --from=builder /deps /deps
COPY --from=builder /hicolor/hicolor /hicolor/hicolor
ENV LD_LIBRARY_PATH=/deps
