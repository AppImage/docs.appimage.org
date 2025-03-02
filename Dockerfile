FROM python:3-alpine as builder

RUN apk add --no-cache gcc musl-dev libffi-dev rust cargo openssl-dev poetry make git bash

# build as a regular user, not root, to avoid annoying warnings from pip
RUN adduser -S build
RUN install -d -m 0755 -o build /build
USER build
WORKDIR /build

COPY pyproject.toml /build/
COPY poetry.lock /build/

RUN poetry install

COPY --chown=build . .

RUN git config --global --add safe.directory /build

RUN poetry run make epub && \
    epub_filename=AppImage-documentation-git"$(date +%Y%m%d)"."$(git rev-parse --short HEAD)".epub && \
    mkdir -p build/html/download && \
    cp build/epub/AppImage.epub build/html/download/"$epub_filename" && \
    bash -xe ci/embed-epub-link.sh "$epub_filename" && \
    poetry run make html


FROM python:3-alpine as libappimage-builder

RUN apk add --no-cache git make doxygen gcc musl-dev libxml2-dev libxslt-dev

WORKDIR /tmp

RUN git clone https://github.com/AppImage/libappimage.git && \
    cd libappimage/docs && \
    pip install -r requirements.txt breathe exhale && \
    make html

# deployment container
FROM nginx:1-alpine

LABEL org.opencontainers.image.source="https://github.com/AppImage/docs.appimage.org"

COPY docker/nginx.conf /etc/nginx/

# check nginx config
RUN nginx -t

COPY --from=builder /build/build/html/ /usr/share/nginx/html
COPY --from=libappimage-builder /tmp/libappimage/docs/_build/html/ /usr/share/nginx/html/api/libappimage
