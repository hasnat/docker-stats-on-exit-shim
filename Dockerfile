FROM alpine:latest
WORKDIR /

COPY shim.sh /docker-stats-on-exit-shim

ENTRYPOINT ["/docker-stats-on-exit-shim"]

CMD ["sleep", "1"]
