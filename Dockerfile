################################
# STEP 1 build executable binary
################################
FROM golang:alpine AS builder
RUN apk update && apk add --no-cache git make build-base
WORKDIR /root/cloud-torrent
ENV PATH=$HOME/go/bin:$PATH 
ENV CGO_ENABLED=1
RUN git clone https://github.com/boypt/simple-torrent.git . && \
    go get -v -t -d .

RUN go build -trimpath -ldflags "-s -w -X main.VERSION=$(git describe --tags)" -o /usr/local/bin/cloud-torrent

############################
# STEP 2 build a small image
############################
FROM alpine
RUN apk update && apk --no-cache add ca-certificates curl zip tar bzip2 gzip vim bash libstdc++
COPY --from=builder /usr/local/bin/cloud-torrent /usr/local/bin/cloud-torrent
# ENTRYPOINT ["cloud-torrent"]
RUN addgroup -S appgroup && adduser -S ctuser -G appgroup
WORKDIR /app
COPY startCloudTorrent.sh .
RUN cp /usr/local/bin/cloud-torrent .
RUN chown -R ctuser:appgroup /app
USER ctuser
RUN chmod +x cloud-torrent
RUN chmod +x startCloudTorrent.sh && echo "Using cloud torrent version: $(cloud-torrent --version)"
EXPOSE 3000
CMD [ "bash", "startCloudTorrent.sh" ]
