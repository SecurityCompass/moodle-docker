FROM certbot/certbot:v0.27.1

RUN apk update && \
	apk add openssl curl

VOLUME /certs
VOLUME /challenges

COPY ./bin/ /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
