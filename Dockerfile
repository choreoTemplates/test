FROM choreoanonymouspullable.azurecr.io/choreoipaas/choreo-ballerina:1.0.2 AS builder

WORKDIR /tmp/
COPY ./project/ /tmp/
RUN bal build || (test -f ballerina-internal.log && cat ballerina-internal.log 1>&2)
RUN test $(find /tmp/target/bin/ -name *.jar)

# temp change to use jdk tools for profiling
FROM adoptopenjdk/openjdk11:jre-11.0.9_11.1-alpine
RUN apk update && apk add bash
RUN addgroup -g 1000 -S choreo && adduser -u 100 -S choreo -G choreo
WORKDIR /home/choreo/
COPY --from=builder /tmp/target/bin/*.jar .
COPY docker-entrypoint.sh .
RUN chown -R choreo:choreo .
USER choreo
ENTRYPOINT ["./docker-entrypoint.sh"]
