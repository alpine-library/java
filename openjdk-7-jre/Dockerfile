FROM alpine:3.2

ENV LANG C.UTF-8

ENV JAVA_VERSION 7u85
ENV JAVA_ALPINE_VERSION 7.85.2.6.1-r0

RUN apk --update add openjdk7-jre=JAVA_ALPINE_VERSION
CMD ["/usr/bin/java", "-version"]
