FROM alpine:3.2

ENV LANG C.UTF-8

ENV JAVA_VERSION 8u66
ENV JAVA_ALPINE_VERSION 8.66.02-r1

RUN apk --update add openjdk7-jre=JAVA_ALPINE_VERSION
CMD ["/usr/bin/java", "-version"]
