FROM alpine:latest
RUN apk add --no-cache bash
WORKDIR /

#COPY --from=builder /docker-stats-on-exit-shim .
COPY shim.sh /docker-stats-on-exit-shim

ENTRYPOINT ["/docker-stats-on-exit-shim"]

CMD ["sleep", "1"]
