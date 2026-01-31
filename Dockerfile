FROM golang:rc-bullseye AS builder

LABEL maintainer="Jennings Liu <jenningsloy318@gmail.com>"

ENV GO111MODULE=on

# Build from local sources
WORKDIR /src
COPY . .
RUN make build

FROM golang:rc-bullseye

COPY --from=builder /src/build/redfish_exporter /usr/local/bin/redfish_exporter
RUN mkdir /etc/prometheus
COPY config.yml.example /etc/prometheus/redfish_exporter.yml
CMD ["/usr/local/bin/redfish_exporter","--config.file","/etc/prometheus/redfish_exporter.yml"]
