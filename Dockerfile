FROM ubuntu:latest

COPY ./catalyst.key /catalyst.key

RUN set -ex \
    && apt-get update \
    && apt-get install --no-install-recommends --no-install-suggests --quiet --yes --verbose-versions \
      gnupg \
    && mkdir -p /var/lib/vim/addons/ftdetect \
    && useradd -ms /bin/bash user \
    && echo "deb http://debian.catalyst.net.nz/catalyst stable catalyst" >> /etc/apt/sources.list \
    && apt-key add - < /catalyst.key \
    && apt-get update \
    && apt-get install --no-install-recommends --no-install-suggests --quiet --yes --verbose-versions \
      tks \
    && rm -rf /var/lib/apt/lists/ \
    && apt-get autoremove --purge --quiet --yes \
    && apt-get purge --quiet --yes \
    && ln -s /timesheets/.tksrc ~user/.tksrc \
    && mkdir -p ~user/.cache \
    && ln -s /timesheets/.tksinfo ~user/.cache/tksinfo \
    && true

USER user
WORKDIR /timesheets
VOLUME /timesheets

CMD "tks -c /timesheets/*.tks"
