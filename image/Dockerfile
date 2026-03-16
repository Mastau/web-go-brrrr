FROM debian:12-slim

COPY sources /root/sources/

WORKDIR /root/sources/install

RUN chmod +x entrypoint.sh
RUN ./entrypoint.sh base
RUN ./entrypoint.sh desktop
RUN ./entrypoint.sh misc
RUN ./entrypoint.sh wordlists
RUN ./entrypoint.sh cracking
RUN ./entrypoint.sh web
RUN ./entrypoint.sh post_build

WORKDIR /workspace

ENTRYPOINT ["entrypoint.sh"]
