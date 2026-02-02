# Loader
FROM alpine:3.23.3 AS loader

ARG MINECRAFT_VERSION=1.21.10

WORKDIR /app

RUN apk add --no-cache bash curl jq coreutils

COPY fetch.sh .

RUN chmod +x fetch.sh && ./fetch.sh ${MINECRAFT_VERSION}

# Runner
FROM alpine/java:21.0.4-jre

WORKDIR /app

COPY --from=loader /app/server.jar .

COPY . .

EXPOSE 25565

CMD ["/opt/java/openjdk/bin/java", "-Xmx1024M", "-Xms1024M", "-jar", "server.jar", "nogui"]